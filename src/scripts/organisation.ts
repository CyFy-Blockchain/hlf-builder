import { caConfig } from "../config/caConfig";
import { upCaShell, updateCaYaml } from "../services/ca";
import { downServices } from "../services/servicesDown";
import { log } from "../utils/logger";

export async function upOrganisation() {
  log("Updating compose/compose-ca.yaml");
  updateCaYaml(caConfig);
  log("compose/compose-ca.yaml has been updated");
  // await upCaShell(caConfig);
}

export async function downOrganisation() {
  await downServices();
}
