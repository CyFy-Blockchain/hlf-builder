import path from "path";

const srcPath = path.join(__dirname, "../../");
const peerBasePath = (orgName: string, nodeIdentifier: string) =>
  path.join(srcPath, `fabric-ca-client/${orgName}/peer/${nodeIdentifier}`);

export const PATHS = {
  // Init commands
  INIT_TLS_CA_SH: path.join(srcPath, "./commands/init/tls-ca.sh"),
  INIT_CLIENT_TLS_CA_SH: path.join(
    srcPath,
    "./commands/init/tls-client-enroll.sh"
  ),
  INIT_CLIENT_ORG_CA_SH: path.join(
    srcPath,
    "./commands/init/org-client-enroll.sh"
  ),
  INIT_ORG_CA_SH: path.join(srcPath, "./commands/init/org-ca.sh"),

  // User registration commands
  USER_REGISTER_NODE_USER: path.join(
    srcPath,
    "./commands/user/register-node-user.sh"
  ),
  USER_REGISTER_USER: path.join(srcPath, "./commands/user/register-user.sh"),

  // Configuration files
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

  PEER_PATHS: {
    INIT_PEER_SH: path.join(srcPath, "./commands/init/peer.sh"),
    START_PEER_SH: path.join(srcPath, "./commands/start/peer.sh"),
    PEER_CONFIG_YAML: (orgName: string, nodeIdentifier: string) =>
      peerBasePath(orgName, nodeIdentifier) + "/core.yaml",
    PEER_TLS_CERT: (orgName: string, nodeIdentifier: string) =>
      peerBasePath(orgName, nodeIdentifier) + "/tls-ca-cert.pem",
    PEER_TLS_PRIV_KEY: (orgName: string, nodeIdentifier: string) =>
      peerBasePath(orgName, nodeIdentifier) + "/tls/msp/keystore/peer-key.pem",
    PEER_TLS_PUB_KEY: (orgName: string, nodeIdentifier: string) =>
      peerBasePath(orgName, nodeIdentifier) + "/tls/msp/signcerts/cert.pem",
    PEER_ORG_MSP: (orgName: string, nodeIdentifier: string) =>
      peerBasePath(orgName, nodeIdentifier) + "/ca/msp",
  },
};
