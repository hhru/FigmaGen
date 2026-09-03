import type { FigmaApi, FigmaNode } from "./figma-api.js";
import { toIconName } from "./names.js";
import type { SfSymbolConfig } from "./sf-symbol-config.js";

export type SfSymbolVariant = {
  size: number;
  variantName: "Regular-S" | "Regular-M";
  scale: number;
  componentId: string;
  width: number;
  height: number;
};

export type SfSymbolCandidate = {
  name: string;
  figmaName: string;
  variants: SfSymbolVariant[];
};

export async function analyzeSfSymbols(
  figma: FigmaApi,
  config: SfSymbolConfig,
): Promise<SfSymbolCandidate[]> {
  const [page] = await figma.getNodes(["0:1"], 2);

  if (page.name !== config.pageName) {
    throw new Error(`Expected page "${config.pageName}", got "${page.name}".`);
  }

  const matchingFrames = (page.children ?? []).filter(
    (node) => node.type === "FRAME" && node.name === config.frameName,
  );
  const framesWithComponents = matchingFrames.filter((frame) =>
    (frame.children ?? []).some((node) => node.type === "COMPONENT_SET"),
  );

  if (framesWithComponents.length !== 1) {
    throw new Error(
      `Expected exactly one non-empty frame named "${config.frameName}", found ${framesWithComponents.length}.`,
    );
  }

  const [frame] = await figma.getNodes([framesWithComponents[0].id], 3);
  const candidates: SfSymbolCandidate[] = [];

  for (const componentSet of (frame.children ?? []).filter(
    (node) => node.type === "COMPONENT_SET",
  )) {
    if (!supportsColoredVariant(componentSet)) {
      continue;
    }

    const variants: SfSymbolVariant[] = [];

    for (const sizeConfig of config.sizes) {
      const component = (componentSet.children ?? []).find(
        (node) =>
          node.type === "COMPONENT" &&
          hasVariantProperties(
            node.name,
            new Map([
              ["size", String(sizeConfig.size)],
              ["colored", "true"],
            ]),
          ),
      );

      if (!component) {
        throw new Error(
          `${componentSet.name} is missing size=${sizeConfig.size}, colored=true.`,
        );
      }

      const box = component.absoluteBoundingBox;

      if (!box) {
        throw new Error(`${componentSet.name} size=${sizeConfig.size} has no bounding box.`);
      }

      if (!approximatelyEqual(box.height, sizeConfig.size)) {
        throw new Error(
          `${componentSet.name} size=${sizeConfig.size} is ${formatSize(box.width)}x${formatSize(box.height)}; expected height ${sizeConfig.size}.`,
        );
      }

      variants.push({
        ...sizeConfig,
        componentId: component.id,
        width: normalizeDimension(box.width),
        height: sizeConfig.size,
      });
    }

    const name = toIconName(`${config.namePrefix} ${componentSet.name}`);

    if (!name) {
      throw new Error(`Could not create an SF Symbol name for "${componentSet.name}".`);
    }

    candidates.push({
      name,
      figmaName: componentSet.name,
      variants: variants.sort((left, right) => left.size - right.size),
    });
  }

  return candidates.sort((left, right) => left.name.localeCompare(right.name, "en"));
}

function supportsColoredVariant(componentSet: FigmaNode): boolean {
  return Object.entries(componentSet.componentPropertyDefinitions ?? {}).some(
    ([name, definition]) =>
      normalize(name) === "colored" &&
      definition.variantOptions?.some((value) => normalize(String(value)) === "true"),
  );
}

function hasVariantProperties(name: string, expected: Map<string, string>): boolean {
  const actual = new Map<string, string>();

  for (const segment of name.split(",")) {
    const separatorIndex = segment.indexOf("=");

    if (separatorIndex === -1) {
      continue;
    }

    actual.set(
      normalize(segment.slice(0, separatorIndex)),
      normalize(segment.slice(separatorIndex + 1)),
    );
  }

  return [...expected].every(([key, value]) => actual.get(key) === normalize(value));
}

function normalize(value: string): string {
  return value.trim().toLocaleLowerCase("en-US");
}

function approximatelyEqual(left: number, right: number): boolean {
  return Math.abs(left - right) < 0.01;
}

function normalizeDimension(value: number): number {
  const rounded = Math.round(value);

  return approximatelyEqual(value, rounded) ? rounded : value;
}

function formatSize(value: number): string {
  return Number.isInteger(value) ? String(value) : value.toFixed(2);
}
