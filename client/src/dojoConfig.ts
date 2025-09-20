import { createDojoConfig } from "@dojoengine/core";

import manifest from "./generated/manifest_dev.json";

export const dojoConfig = createDojoConfig({
  manifest,
});
