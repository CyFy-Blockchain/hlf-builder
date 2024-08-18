import yaml from "yaml";
import fs from "fs";

import { PATHS } from "../constants/paths";
import { OrgCaConfigs } from "../interfaces/org-ca";
import { runCommand } from "../utils/helper";
import { config } from "../config/default";

const orgConfig: OrgCaConfigs = {
  caAdminUser: config.rcaAdmin.user,
  caAdminPassword: config.rcaAdmin.pwd,
  orgName: config.orgName,
  listenAddress: config.rcaListenAddress,
  port: config.rcaHosting.port,
  csrHosts: [config.rcaHosting.host],
};

export async function initializeOrganizationCA(orgConfig: OrgCaConfigs) {
  await runCommand(`bash ${PATHS.INIT_ORG_CA_SH}`, [
    orgConfig.caAdminUser,
    orgConfig.caAdminPassword,
  ]);
}

export function updateOrganizationCA(orgConfig: OrgCaConfigs) {
  // update the configuration to TLS configuration
  const fileContent = fs.readFileSync(PATHS.CA_ORG_SERVER_CONFIG_YAML, "utf8");
  const yamlData = yaml.parse(fileContent);

  yamlData.tls.enabled = true;
  yamlData.tls.certfile = PATHS.CA_ORG_ADMIN_CREDS.CERT;
  yamlData.tls.keystore = PATHS.CA_ORG_ADMIN_CREDS.KEY;
  yamlData.ca.name = orgConfig.orgName;

  if (orgConfig.port) yamlData.port = orgConfig.port;
  if (orgConfig.csrHosts) yamlData.csr.hosts = orgConfig.csrHosts;
  if (orgConfig.listenAddress)
    yamlData.operations.listenAddress = orgConfig.listenAddress;
  if (orgConfig.caHierarchyLength) {
    yamlData.csr.ca.pathlength = orgConfig.caHierarchyLength;
    yamlData.signing.profiles.ca.caconstraint.maxpathlen =
      orgConfig.caHierarchyLength;
  }

  // update the .yaml
  const newContent = yaml.stringify(yamlData);
  fs.writeFileSync(PATHS.CA_ORG_SERVER_CONFIG_YAML, newContent, "utf8");
}

(async () => {
  await initializeOrganizationCA(orgConfig);
  updateOrganizationCA(orgConfig);
})();
