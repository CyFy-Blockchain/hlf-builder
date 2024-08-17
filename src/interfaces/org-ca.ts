export type OrgCaConfigs = {
  caAdminUser: string;
  caAdminPassword: string;
  orgName: string;
  port?: number;
  certfilePath?: string;
  keyFilePath?: string;
  csrHosts?: string[];
  caHierarchyLength?: number;
  listenAddress?: string;
};
