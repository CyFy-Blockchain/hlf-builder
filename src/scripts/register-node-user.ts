import { config } from "../config/default";
import { PATHS } from "../constants/paths";
import { NodeType, NodeUserEnrollment } from "../interfaces/user-enrollment";
import { generateUuid, runCommand } from "../utils/helper";

const tlsAdminConfig: NodeUserEnrollment = {
  username: config.peer.username,
  password: config.peer.password,
  rcaHostName: config.rcaHosting.host,
  rcaPort: config.rcaHosting.port,
  tlsHostName: config.tlsHosting.host,
  tlsPort: config.tlsHosting.port,
  orgName: config.orgName,
  nodeType: NodeType.ADMIN,
  nodeIdentifier: generateUuid(),
};

async function registerNodeUser(args: NodeUserEnrollment) {
  await runCommand(`bash ${PATHS.USER_REGISTER_NODE_USER}`, [
    args.username,
    args.password,
    args.rcaHostName,
    args.rcaPort,
    args.tlsHostName,
    args.tlsPort,
    args.orgName,
    args.nodeType,
    args.nodeIdentifier,
  ]);
}

(async () => {
  await registerNodeUser(tlsAdminConfig);
})();
