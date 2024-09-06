import fs from "fs";
import yaml from "yaml";

import { CaConfig } from "../interface/ca";
import { PATHS } from "../utils/paths";
import { runCommand, updateKeyValueInArray } from "../utils/helper";

export function updateCaYaml(caConfig: CaConfig) {
  // Update the .yaml file
  const fileContent = fs.readFileSync(PATHS.FETCH_CA_YAML, "utf8");
  const yamlData = yaml.parse(fileContent);

  const serverConfig = yamlData.services.ca_org1;

  // update ca server name
  updateKeyValueInArray(
    serverConfig.environment,
    "FABRIC_CA_SERVER_CA_NAME",
    "ca-" + caConfig.orgName
  );

  // update ca server port
  updateKeyValueInArray(
    serverConfig.environment,
    "FABRIC_CA_SERVER_PORT",
    caConfig.serverConnection.port
  );

  // update ca operations listen address
  updateKeyValueInArray(
    serverConfig.environment,
    "FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS",
    caConfig.operations.host + ":" + caConfig.operations.port
  );

  // update ports
  serverConfig.ports = [
    `${caConfig.serverConnection.port}:${caConfig.serverConnection.port}`,
    `${caConfig.operations.port}:${caConfig.operations.port}`,
  ];

  // update start command with updated admin creds
  serverConfig.command = `sh -c 'fabric-ca-server start -b ${caConfig.admin.username}:${caConfig.admin.password} -d'`;

  // update directory for the organization
  serverConfig.volumes = [
    `../organizations/fabric-ca/${caConfig.orgName}:/etc/hyperledger/fabric-ca-server`,
  ];

  // update container name
  serverConfig.container_name = "ca-" + caConfig.orgName;

  yamlData.services = { [caConfig.orgName]: serverConfig };

  // update the .yaml
  const newContent = yaml.stringify(yamlData);
  fs.writeFileSync(PATHS.POST_CA_YAML, newContent, "utf8");
}

export async function upCaShell(caConfig: CaConfig) {
  return await runCommand(`bash ${PATHS.STRUCTURE_UP}`, [
    caConfig.orgName,
    caConfig.admin.username,
    caConfig.admin.password,
    caConfig.serverConnection.port,
    caConfig.serverConnection.host,
  ]);
}
