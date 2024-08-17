import { initOrgCa } from "./controller/org-ca";
import { createTlsCa } from "./controller/tls-ca";
import {
  enrollUserOnOrgCA,
  enrollUserOnTLS,
} from "./controller/user-enrollment";

const tlsAdmin = {
  user: "mhtariq29",
  pwd: "t123",
};

const rcaAdmin = {
  user: "hassan",
  pwd: "tca123",
};

const orgName = "UMS";

const tlsHosting = {
  host: "localhost",
  port: 7055,
};

const rcaHosting = {
  host: "localhost",
  port: 7054,
};
// First run this to init a tls server and update the config
// createTlsCa({
//   adminUser: tlsAdmin.user,
//   adminPwd: tlsAdmin.pwd,
//   orgName: orgName,
//   csrHosts: [tlsHosting.host],
//   port: tlsHosting.port,
// });

// start the TLS server running sh ./commands/start/tls-ca.sh

// run this to enroll the TLS admin and create a rca admin
// enrollUserOnTLS({
//   adminUsernameTls: tlsAdmin.user,
//   adminPasswordTls: tlsAdmin.pwd,
//   orgName: orgName,
//   hostName: tlsHosting.host,
//   port: tlsHosting.port,
//   caAdminUsername: rcaAdmin.user,
//   caAdminPassword: rcaAdmin.pwd,
// });

// run the command to init org deployment
// initOrgCa({
//   caAdminUser: rcaAdmin.user,
//   caAdminPassword: rcaAdmin.pwd,
//   orgName,
//   listenAddress: "127.0.0.1:9444",
//   port: rcaHosting.port,
//   csrHosts: [rcaHosting.host],
// });

// start the CA server running sh ./commands/start/org-ca.sh

// enroll user on org server
enrollUserOnOrgCA({
  caAdminUsername: rcaAdmin.user,
  caAdminPassword: rcaAdmin.pwd,
  orgName: orgName,
  hostName: rcaHosting.host,
  port: rcaHosting.port,
});
