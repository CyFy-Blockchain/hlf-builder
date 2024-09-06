import { CaConfig } from "../interface/ca";

export const caConfig: CaConfig = {
  orgName: "FAST",
  serverConnection: {
    port: 7054,
    host: "localhost",
  },
  operations: {
    port: 17054,
    host: "0.0.0.0",
  },
  admin: {
    username: "admin",
    password: "adminpw",
  },
};
