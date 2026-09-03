import fs from "node:fs/promises";
import path from "node:path";
import { SVGPathData, SVGPathDataTransformer } from "svg-pathdata";
import type { FigmaApi } from "./figma-api.js";
import type { SfSymbolCandidate, SfSymbolVariant } from "./sf-symbol-analysis.js";
import type { SfSymbolConfig } from "./sf-symbol-config.js";
import { convertEvenoddPathToNonzero } from "./svg-path-winding.js";

type SymbolLayer = {
  role: "primary" | "secondary";
  pathData: string;
};

type ParsedVariant = {
  variant: SfSymbolVariant;
  layers: SymbolLayer[];
};

export type SfSymbolGenerationResult = {
  assetCatalogPath: string;
  reportPath: string;
  symbolCount: number;
};

const capHeight = 70.459;
const emDesignHeight = 100;
const symbolCenterX = 1449.845;
const symbolCenterY = -capHeight / 2;

export async function generateSfSymbols(
  figma: FigmaApi,
  candidates: SfSymbolCandidate[],
  config: SfSymbolConfig,
): Promise<SfSymbolGenerationResult> {
  const assetCatalogPath = path.join(config.outputDir, config.assetCatalogName);
  const reportPath = path.join(config.outputDir, "validation-report.json");

  await fs.rm(config.rawOutputDir, { recursive: true, force: true });
  await fs.rm(config.outputDir, { recursive: true, force: true });
  await fs.mkdir(config.rawOutputDir, { recursive: true });
  await fs.mkdir(assetCatalogPath, { recursive: true });
  await writeJson(path.join(assetCatalogPath, "Contents.json"), {
    info: { author: "xcode", version: 1 },
  });

  const exportedSvgs = await exportRawSvgs(figma, candidates, config);
  const reportSymbols: Array<{
    name: string;
    figmaName: string;
    variants: Array<{
      size: number;
      sfSymbolVariant: string;
      pathCount: number;
      sourceBox: { width: number; height: number };
      designBox: { width: number; height: number };
      artworkBounds: { width: number; height: number };
    }>;
  }> = [];

  for (const candidate of candidates) {
    const parsedVariants = candidate.variants.map((variant) => {
      const svg = exportedSvgs.get(exportKey(candidate.name, variant.size));

      if (!svg) {
        throw new Error(`Missing exported SVG for ${candidate.name} size=${variant.size}.`);
      }

      return parseVariant(svg, candidate.name, variant, config);
    });

    validateSynchronizedLayers(candidate.name, parsedVariants);

    const symbolSetPath = path.join(assetCatalogPath, `${candidate.name}.symbolset`);
    const symbolFilename = `${candidate.name}.svg`;
    await fs.mkdir(symbolSetPath, { recursive: true });
    await fs.writeFile(
      path.join(symbolSetPath, symbolFilename),
      renderSymbolTemplate(candidate.name, parsedVariants),
    );
    await writeJson(path.join(symbolSetPath, "Contents.json"), {
      images: [{ filename: symbolFilename, idiom: "universal" }],
      info: { author: "xcode", version: 1 },
    });

    reportSymbols.push({
      name: candidate.name,
      figmaName: candidate.figmaName,
      variants: parsedVariants.map(({ variant, layers }) => ({
        size: variant.size,
        sfSymbolVariant: variant.variantName,
        pathCount: layers.length,
        sourceBox: {
          width: roundNumber(variant.width),
          height: roundNumber(variant.height),
        },
        designBox: getDesignBox(variant),
        artworkBounds: getArtworkBounds(layers),
      })),
    });
  }

  await writeJson(reportPath, {
    status: "valid",
    renderingMode: "palette",
    layerMapping: {
      black: "primary",
      red: "secondary",
    },
    symbolCount: candidates.length,
    symbols: reportSymbols,
  });

  return {
    assetCatalogPath,
    reportPath,
    symbolCount: candidates.length,
  };
}

async function exportRawSvgs(
  figma: FigmaApi,
  candidates: SfSymbolCandidate[],
  config: SfSymbolConfig,
): Promise<Map<string, string>> {
  const exports = candidates.flatMap((candidate) =>
    candidate.variants.map((variant) => ({ candidate, variant })),
  );
  const svgs = new Map<string, string>();

  for (const exportChunk of chunk(exports, 30)) {
    const urls = await figma.getSvgUrls(
      exportChunk.map(({ variant }) => variant.componentId),
    );

    await Promise.all(
      exportChunk.map(async ({ candidate, variant }) => {
        const url = urls.get(variant.componentId);

        if (!url) {
          throw new Error(`Missing SVG URL for ${candidate.name} size=${variant.size}.`);
        }

        const svg = await figma.downloadSvg(url);
        const sizeDirectory = path.join(config.rawOutputDir, String(variant.size));
        await fs.mkdir(sizeDirectory, { recursive: true });
        await fs.writeFile(path.join(sizeDirectory, `${candidate.name}.svg`), svg);
        svgs.set(exportKey(candidate.name, variant.size), svg);
      }),
    );
  }

  return svgs;
}

function parseVariant(
  svg: string,
  iconName: string,
  variant: SfSymbolVariant,
  config: SfSymbolConfig,
): ParsedVariant {
  validateSvgFeatures(svg, iconName, variant);

  const svgTag = svg.match(/<svg\b[^>]*>/i)?.[0];

  if (!svgTag) {
    throw new Error(`${iconName} size=${variant.size} has no <svg> element.`);
  }

  const width = readNumberAttribute(svgTag, "width");
  const height = readNumberAttribute(svgTag, "height");

  if (!approximatelyEqual(width, variant.width) || !approximatelyEqual(height, variant.height)) {
    throw new Error(
      `${iconName} size=${variant.size} exported as ${width}x${height}; expected ${variant.width}x${variant.height}.`,
    );
  }

  const primaryFills = new Set(config.primaryFills.map(normalizeFill));
  const secondaryFills = new Set(config.secondaryFills.map(normalizeFill));
  const layers: SymbolLayer[] = [];

  for (const pathMatch of svg.matchAll(/<path\b([^>]*)\/?\s*>/gi)) {
    const pathTag = pathMatch[0];
    const fill = normalizeFill(readStringAttribute(pathTag, "fill") ?? "");
    const pathData = readStringAttribute(pathTag, "d");

    if (!pathData) {
      throw new Error(`${iconName} size=${variant.size} contains a path without path data.`);
    }

    let role: SymbolLayer["role"];

    if (primaryFills.has(fill)) {
      role = "primary";
    } else if (secondaryFills.has(fill)) {
      role = "secondary";
    } else {
      throw new Error(
        `${iconName} size=${variant.size} contains unsupported path fill "${fill || "missing"}".`,
      );
    }

    const fillRule = readStringAttribute(pathTag, "fill-rule")?.toLowerCase();
    const normalizedPathData =
      fillRule === "evenodd"
        ? convertEvenoddPathToNonzero(pathData, variant.width, variant.height)
        : pathData;

    layers.push({ role, pathData: transformPath(normalizedPathData, variant) });
  }

  if (layers.length === 0) {
    throw new Error(`${iconName} size=${variant.size} contains no paths.`);
  }

  if (!layers.some((layer) => layer.role === "primary")) {
    throw new Error(`${iconName} size=${variant.size} has no black primary layer.`);
  }

  if (!layers.some((layer) => layer.role === "secondary")) {
    throw new Error(`${iconName} size=${variant.size} has no red secondary layer.`);
  }

  return { variant, layers };
}

function validateSvgFeatures(svg: string, iconName: string, variant: SfSymbolVariant): void {
  const unsupportedFeatures: Array<[string, RegExp]> = [
    ["raster image", /<image\b/i],
    ["gradient", /<(?:linearGradient|radialGradient)\b/i],
    ["mask", /<mask\b|\bmask=/i],
    ["filter", /<filter\b|\bfilter=/i],
    ["pattern", /<pattern\b/i],
    ["style", /<style\b/i],
    ["stroke", /\bstroke="(?!none")/i],
    ["transform", /\btransform=/i],
  ];

  for (const [feature, pattern] of unsupportedFeatures) {
    if (pattern.test(svg)) {
      throw new Error(`${iconName} size=${variant.size} contains unsupported ${feature}.`);
    }
  }
}

function validateSynchronizedLayers(iconName: string, variants: ParsedVariant[]): void {
  const [reference, ...others] = variants;
  const referenceRoles = reference.layers.map((layer) => layer.role).join(",");

  for (const variant of others) {
    const roles = variant.layers.map((layer) => layer.role).join(",");

    if (roles !== referenceRoles) {
      throw new Error(
        `${iconName} has incompatible layer order between ${reference.variant.variantName} (${referenceRoles}) and ${variant.variant.variantName} (${roles}).`,
      );
    }
  }
}

function transformPath(pathData: string, variant: SfSymbolVariant): string {
  const { height: targetHeight } = getDesignBox(variant);
  const scale = targetHeight / variant.height;
  const offsetY = symbolCenterY - targetHeight / 2;

  return new SVGPathData(pathData)
    .transform(SVGPathDataTransformer.MATRIX(scale, 0, 0, scale, 0, offsetY))
    .transform(SVGPathDataTransformer.ROUND(6))
    .encode();
}

function getDesignBox(variant: SfSymbolVariant): { width: number; height: number } {
  const height = emDesignHeight * variant.scale;

  return {
    width: roundNumber(variant.width * (height / variant.height)),
    height: roundNumber(height),
  };
}

function getArtworkBounds(layers: SymbolLayer[]): { width: number; height: number } {
  const bounds = layers.map((layer) => new SVGPathData(layer.pathData).getBounds());
  const minX = Math.min(...bounds.map((box) => box.minX));
  const minY = Math.min(...bounds.map((box) => box.minY));
  const maxX = Math.max(...bounds.map((box) => box.maxX));
  const maxY = Math.max(...bounds.map((box) => box.maxY));

  return {
    width: roundNumber(maxX - minX),
    height: roundNumber(maxY - minY),
  };
}

function renderSymbolTemplate(name: string, variants: ParsedVariant[]): string {
  const variantMarkup = variants
    .map(({ variant, layers }) => {
      const targetWidth = getDesignBox(variant).width;
      const originX = symbolCenterX - targetWidth / 2;
      const paths = layers
        .map(
          (layer, index) =>
            `    <path class="hierarchical-${index}:${layer.role} SFSymbolsPreview${layer.role === "primary" ? "212121" : "4D4D4D"}" d="${escapeXml(layer.pathData)}"/>`,
        )
        .join("\n");

      return `  <g id="${variant.variantName}" transform="matrix(1 0 0 1 ${formatNumber(originX)} ${baselineForVariant(variant.variantName)})">\n${paths}\n  </g>`;
    })
    .join("\n");
  const marginGuides = variants.map(renderMarginGuides).join("\n");

  return `<?xml version="1.0" encoding="UTF-8"?>
<!-- Generated from Figma. Do not edit manually. -->
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="3300" height="2200">
 <style>
  .hierarchical-0:primary {fill:#212121}
  .hierarchical-1:secondary {fill:#4D4D4D}
  .SFSymbolsPreview212121 {fill:#212121;opacity:1.0}
  .SFSymbolsPreview4D4D4D {fill:#4D4D4D;opacity:1.0}
 </style>
 <g id="Notes">
  <rect id="artboard" width="3300" height="2200" x="0" y="0" style="fill:white;opacity:1"/>
  <text id="template-version" transform="matrix(1 0 0 1 3036 1933)" style="font-family:sans-serif;font-size:13;text-anchor:end">Template v.3.0</text>
  <text id="descriptive-name" transform="matrix(1 0 0 1 3036 1969)" style="font-family:sans-serif;font-size:13;text-anchor:end">${escapeXml(name)}</text>
 </g>
 <g id="Guides">
  <line id="Baseline-S" x1="263" x2="3036" y1="696" y2="696"/>
  <line id="Capline-S" x1="263" x2="3036" y1="625.541" y2="625.541"/>
  <line id="Baseline-M" x1="263" x2="3036" y1="1126" y2="1126"/>
  <line id="Capline-M" x1="263" x2="3036" y1="1055.541" y2="1055.541"/>
  <line id="Baseline-L" x1="263" x2="3036" y1="1556" y2="1556"/>
  <line id="Capline-L" x1="263" x2="3036" y1="1485.541" y2="1485.541"/>
${marginGuides}
 </g>
 <g id="Symbols">
${variantMarkup}
 </g>
</svg>
`;
}

function renderMarginGuides({ variant }: ParsedVariant): string {
  const targetWidth = getDesignBox(variant).width;
  const originX = symbolCenterX - targetWidth / 2;
  const baseline = baselineForVariant(variant.variantName);
  const guideTop = baseline - 95.215;
  const guideBottom = baseline + 24.121;

  return `  <line id="left-margin-${variant.variantName}" x1="${formatNumber(originX)}" x2="${formatNumber(originX)}" y1="${formatNumber(guideTop)}" y2="${formatNumber(guideBottom)}"/>
  <line id="right-margin-${variant.variantName}" x1="${formatNumber(originX + targetWidth)}" x2="${formatNumber(originX + targetWidth)}" y1="${formatNumber(guideTop)}" y2="${formatNumber(guideBottom)}"/>`;
}

function baselineForVariant(variantName: SfSymbolVariant["variantName"]): number {
  return variantName === "Regular-S" ? 696 : 1126;
}

function readNumberAttribute(tag: string, name: string): number {
  const value = readStringAttribute(tag, name);
  const numberValue = Number(value);

  if (!value || !Number.isFinite(numberValue)) {
    throw new Error(`Missing or invalid ${name} attribute.`);
  }

  return numberValue;
}

function readStringAttribute(tag: string, name: string): string | null {
  return tag.match(new RegExp(`\\b${name}="([^"]+)"`, "i"))?.[1] ?? null;
}

function normalizeFill(fill: string): string {
  return fill.trim().toLocaleLowerCase("en-US");
}

function approximatelyEqual(left: number, right: number): boolean {
  return Math.abs(left - right) < 0.01;
}

function exportKey(name: string, size: number): string {
  return `${name}:${size}`;
}

function escapeXml(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll('"', "&quot;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;");
}

function formatNumber(value: number): string {
  return Number(value.toFixed(3)).toString();
}

function roundNumber(value: number): number {
  return Number(value.toFixed(3));
}

async function writeJson(filePath: string, value: unknown): Promise<void> {
  await fs.writeFile(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

function chunk<T>(items: T[], size: number): T[][] {
  const chunks: T[][] = [];

  for (let index = 0; index < items.length; index += size) {
    chunks.push(items.slice(index, index + size));
  }

  return chunks;
}
