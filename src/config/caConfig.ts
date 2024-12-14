import { CaConfig } from "../interface/ca";

export const caConfig: CaConfig = {
  orgName: "NUST",
  serverConnection: {
    port: 7055,
    host: "localhost",
  },
  operations: {
    port: 17055,
    host: "0.0.0.0",
  },
  admin: {
    username: "admin",
    password: "adminpw",
  },
};
