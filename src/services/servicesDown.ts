import { runCommand } from "../utils/helper";
import { PATHS } from "../utils/paths";

export async function downServices() {
  return await runCommand(`bash ${PATHS.NETWORK_SH}`, ["down"]);
}
