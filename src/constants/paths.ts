import path from "path";

const srcPath = path.join(__dirname, "../../");

export const PATHS = {
  INIT_TLS_CA_SH: path.join(srcPath, "./commands/init/tls-ca.sh"),
  START_TLS_CA_SH: path.join(srcPath, "./commands/start/tls-ca.sh"),
  TLS_SERVER_CONFIG_YAML: path.join(
    srcPath,
    "./fabric-ca-server-tls/fabric-ca-server-config.yaml"
  ),
  CA_ORG_SERVER_CONFIG_YAML: path.join(
    srcPath,
    "./fabric-ca-server/fabric-ca-server-config.yaml"
  ),
  CA_ORG_ADMIN_CREDS: {
    CERT: path.join(srcPath, "fabric-ca-server/tls/cert.pem"),
    KEY: path.join(srcPath, "fabric-ca-server/tls/key.pem"),
  },
  INIT_CLIENT_TLS_CA_SH: path.join(
    srcPath,
    "./commands/init/tls-client-enroll.sh"
  ),
  INIT_CLIENT_ORG_CA_SH: path.join(
    srcPath,
    "./commands/init/org-client-enroll.sh"
  ),
  INIT_ORG_CA_SH: path.join(srcPath, "./commands/init/org-ca.sh"),
};
