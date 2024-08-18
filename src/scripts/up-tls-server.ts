import yaml from "yaml";
import fs from "fs";

import { PATHS } from "../constants/paths";
import { runCommand } from "../utils/helper";
import { TlsCaArgs } from "../interfaces/tls-ca";
import { config } from "../config/default";

const tlsCaConfigArgs: TlsCaArgs = {
  adminUser: config.tlsAdmin.user,
  adminPwd: config.tlsAdmin.pwd,
  orgName: config.orgName,
  csrHosts: [config.tlsHosting.host],
  port: config.tlsHosting.port,
};

async function generateTlsCa(args: TlsCaArgs) {
  // create fabrci-ca-server-config.yaml file
  const { adminPwd, adminUser, orgName, ...config } = args;
  await runCommand(`sh ${PATHS.INIT_TLS_CA_SH}`, [
    adminUser,
    adminPwd,
    orgName,
  ]);
}

async function updateTlsCa(args: TlsCaArgs) {
  const { adminPwd, adminUser, orgName, ...config } = args;
  // update the configuration to TLS configuration
  const fileContent = fs.readFileSync(PATHS.TLS_SERVER_CONFIG_YAML, "utf8");
  const yamlData = yaml.parse(fileContent);

  // default configurations
  yamlData.tls.enabled = true;
  yamlData.ca.name = orgName;
  delete yamlData.signing.profiles.ca;

  // optional configurations
  if (config.csrHosts) yamlData.csr.hosts = config.csrHosts;
  if (config.listenAddress)
    yamlData.oeprations.listenAddress = config.listenAddress;
  if (config.port) yamlData.port = Number(config.port);

  // update the .yaml
  const newContent = yaml.stringify(yamlData);
  fs.writeFileSync(PATHS.TLS_SERVER_CONFIG_YAML, newContent, "utf8");
}

(async () => {
  await generateTlsCa(tlsCaConfigArgs);
  updateTlsCa(tlsCaConfigArgs);
})();
