import path from "node:path";
import { pathToFileURL } from "node:url";

export type SfSymbolSizeConfig = {
  size: number;
  variantName: "Regular-S" | "Regular-M";
  scale: number;
};

export type SfSymbolConfig = {
  figmaFileKey: string;
  pageName: string;
  frameName: string;
  namePrefix: string;
  sizes: SfSymbolSizeConfig[];
  rawOutputDir: string;
  outputDir: string;
  assetCatalogName: string;
  primaryFills: string[];
  secondaryFills: string[];
};

export async function loadSfSymbolConfig(): Promise<SfSymbolConfig> {
  const configPath = path.resolve("magritte-sf-symbols.config.ts");
  const configModule = (await import(pathToFileURL(configPath).href)) as {
    default?: SfSymbolConfig;
  };

  if (!configModule.default) {
    throw new Error("magritte-sf-symbols.config.ts must export a default config object.");
  }

  return configModule.default;
}
