import { ScriptMode } from "./interface/cliArgs";
import { downOrganisation, upOrganisation } from "./scripts/organisation";
import { parseMode } from "./utils/helper";

const [mode] = process.argv.slice(2);

const scriptMode = parseMode(mode);
if (scriptMode === ScriptMode.Up) {
  upOrganisation();
}
if (scriptMode === ScriptMode.Down) {
  downOrganisation();
}
