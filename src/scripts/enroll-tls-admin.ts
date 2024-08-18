import { config } from "../config/default";
import { PATHS } from "../constants/paths";
import { UserEnrollmentTLS } from "../interfaces/user-enrollment";
import { runCommand } from "../utils/helper";

const tlsAdminConfig: UserEnrollmentTLS = {
  adminUsernameTls: config.tlsAdmin.user,
  adminPasswordTls: config.tlsAdmin.pwd,
  orgName: config.orgName,
  hostName: config.tlsHosting.host,
  port: config.tlsHosting.port,
  caAdminUsername: config.rcaAdmin.user,
  caAdminPassword: config.rcaAdmin.pwd,
};
async function enrollTLSAdmin(user: UserEnrollmentTLS) {
  await runCommand(`sh ${PATHS.INIT_CLIENT_TLS_CA_SH}`, [
    user.adminUsernameTls,
    user.adminPasswordTls,
    user.orgName,
    user.hostName,
    user.port,
    user.caAdminUsername,
    user.caAdminPassword,
  ]);
}

(async () => {
  // run this to enroll the TLS admin and create a rca admin
  await enrollTLSAdmin(tlsAdminConfig);
})();
