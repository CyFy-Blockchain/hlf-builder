import yaml from "yaml";
import fs from "fs";

import { config } from "../config/default";
import { PATHS } from "../constants/paths";
import { PeerConfig } from "../interfaces/peer";
import { runCommand } from "../utils/helper";

const peerConfig: PeerConfig = {
  nodeIdentifier: "8bc631f7-e262-43f0-af58-791820422fbf",
  orgName: config.orgName,
};

function getRequiredPaths(args: PeerConfig) {
  const privKeyPath = PATHS.PEER_PATHS.PEER_TLS_PRIV_KEY(
    args.orgName,
    args.nodeIdentifier
  );
  const pubKeyPath = PATHS.PEER_PATHS.PEER_TLS_PUB_KEY(
    args.orgName,
    args.nodeIdentifier
  );
  const tlsCertPath = PATHS.PEER_PATHS.PEER_TLS_CERT(
    args.orgName,
    args.nodeIdentifier
  );
  const peerConfigPath = PATHS.PEER_PATHS.PEER_CONFIG_YAML(
    args.orgName,
    args.nodeIdentifier
  );
  const peerOrgMsp = PATHS.PEER_PATHS.PEER_ORG_MSP(
    args.orgName,
    args.nodeIdentifier
  );
  const caKey = PATHS.PEER_PATHS.PEER_CA_KEY(args.orgName, args.nodeIdentifier);
  return {
    privKeyPath,
    tlsCertPath,
    peerConfigPath,
    pubKeyPath,
    peerOrgMsp,
    caKey,
  };
}

async function initPeer(args: PeerConfig) {
  await runCommand(`bash ${PATHS.PEER_PATHS.INIT_PEER_SH}`, [
    args.nodeIdentifier,
    args.orgName,
  ]);
}

async function updatePeerConfiguration(args: PeerConfig) {
  const {
    privKeyPath,
    pubKeyPath,
    tlsCertPath,
    peerConfigPath,
    peerOrgMsp,
    caKey,
  } = getRequiredPaths(args);

  const fileContent = fs.readFileSync(peerConfigPath, "utf8");
  const yamlData = yaml.parse(fileContent);

  // update tls configurations
  yamlData.peer.tls.enabled = true;
  yamlData.peer.tls.rootcert.file = tlsCertPath;
  yamlData.peer.tls.cert.file = pubKeyPath;
  yamlData.peer.tls.key.file = privKeyPath;

  // update org ca configuration
  yamlData.peer.mspConfigPath = peerOrgMsp;

  delete yamlData.peer.BCCSP.PKCS11;
  yamlData.peer.BCCSP.SW.FileKeyStore.KeyStore = caKey;
  // update the .yaml
  const newContent = yaml.stringify(yamlData);
  fs.writeFileSync(peerConfigPath, newContent, "utf8");
}

async function startPeerNode(args: PeerConfig) {
  await runCommand(`bash ${PATHS.PEER_PATHS.START_PEER_SH}`, [
    args.nodeIdentifier,
    args.orgName,
  ]);
}

(async () => {
  await initPeer(peerConfig);
  updatePeerConfiguration(peerConfig);
  await startPeerNode(peerConfig);
})();
