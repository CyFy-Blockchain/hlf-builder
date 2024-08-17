import { TlsCaArgs } from "../interfaces/tls-ca";
import { UserEnrollmentTLS } from "../interfaces/user-enrollment";
import { generateTlsCa, startTlsCa, updateTlsCa } from "../lib/tls-ca";

export async function createTlsCa(args: TlsCaArgs) {
  await generateTlsCa(args);
  updateTlsCa(args);
  // await startTlsCa();
}
