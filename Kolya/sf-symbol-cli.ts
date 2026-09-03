#!/usr/bin/env node

import { getFigmaToken } from "./config.js";
import { FigmaApi } from "./figma-api.js";
import { analyzeSfSymbols } from "./sf-symbol-analysis.js";
import { loadSfSymbolConfig } from "./sf-symbol-config.js";
import { generateSfSymbols } from "./sf-symbol-generation.js";

try {
  const config = await loadSfSymbolConfig();
  const figma = new FigmaApi(config.figmaFileKey, getFigmaToken());
  const candidates = await analyzeSfSymbols(figma, config);

  if (candidates.length === 0) {
    throw new Error(
      `No component sets with colored=true variants found in frame "${config.frameName}".`,
    );
  }

  console.log(`Colored SF Symbols found: ${candidates.length}`);
  const result = await generateSfSymbols(figma, candidates, config);
  console.log(`Generated ${result.symbolCount} Palette SF Symbols`);
  console.log(`Asset catalog: ${result.assetCatalogPath}`);
  console.log(`Validation report: ${result.reportPath}`);
} catch (error) {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
}
