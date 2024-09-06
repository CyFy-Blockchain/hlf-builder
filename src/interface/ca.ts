import { Credentials, ServerInfo } from "./appInterface";

export type CaConfig = {
  orgName: string;
  serverConnection: ServerInfo;
  operations: ServerInfo;
  admin: Credentials;
};
