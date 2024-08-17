import {
  UserEnrollmentOrgCA,
  UserEnrollmentTLS,
} from "../interfaces/user-enrollment";
import { enrollOrgCaUser, enrollTLSUser } from "../lib/user-enrollment";

export async function enrollUserOnTLS(args: UserEnrollmentTLS) {
  await enrollTLSUser(args);
}

export async function enrollUserOnOrgCA(args: UserEnrollmentOrgCA) {
  await enrollOrgCaUser(args);
}
