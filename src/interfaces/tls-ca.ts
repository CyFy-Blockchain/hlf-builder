export type TlsCaArgs = {
  adminUser: string;
  adminPwd: string;
  orgName: string;
  port?: number;
  listenAddress?: string;
  csrHosts?: string[];
};
