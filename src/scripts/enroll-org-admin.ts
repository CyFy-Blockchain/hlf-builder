import { config } from "../config/default";
import { PATHS } from "../constants/paths";
import { UserEnrollmentOrgCA } from "../interfaces/user-enrollment";
import { runCommand } from "../utils/helper";

const args: UserEnrollmentOrgCA = {
  caAdminUsername: config.rcaAdmin.user,
  caAdminPassword: config.rcaAdmin.pwd,
  orgName: config.orgName,
  hostName: config.rcaHosting.host,
  port: config.rcaHosting.port,
};
async function enrollOrgCaUser(user: UserEnrollmentOrgCA) {
  await runCommand(`sh ${PATHS.INIT_CLIENT_ORG_CA_SH}`, [
    user.caAdminUsername,
    user.caAdminPassword,
    user.orgName,
    user.hostName,
    user.port,
  ]);
}

(async () => {
  await enrollOrgCaUser(args);
})();
