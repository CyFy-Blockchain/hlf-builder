import path from "path";

const srcPath = path.join(__dirname, "../../");

export const PATHS = {
  FETCH_CA_YAML: path.join(srcPath, "./dockerResources/compose-ca.yaml"),
  POST_CA_YAML: path.join(srcPath, "./compose/compose-ca.yaml"),
  STRUCTURE_UP: path.join(srcPath, "/structure-up.sh"),
  NETWORK_SH: path.join(srcPath, "/network.sh"),
};
