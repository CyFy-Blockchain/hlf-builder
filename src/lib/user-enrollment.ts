import { PATHS } from "../constants/paths";
import {
  UserEnrollmentOrgCA,
  UserEnrollmentTLS,
} from "../interfaces/user-enrollment";
import { runCommand } from "../utils/helper";

export async function enrollTLSUser(user: UserEnrollmentTLS) {
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

export async function enrollOrgCaUser(user: UserEnrollmentOrgCA) {
  await runCommand(`sh ${PATHS.INIT_CLIENT_ORG_CA_SH}`, [
    user.caAdminUsername,
    user.caAdminPassword,
    user.orgName,
    user.hostName,
    user.port,
  ]);
}
