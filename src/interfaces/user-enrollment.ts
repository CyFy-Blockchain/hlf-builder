export enum NodeType {
  CLIENT = "client",
  ADMIN = "admin",
  PEER = "peer",
  ORDERER = "orderer",
}

export type UserEnrollmentTLS = {
  adminUsernameTls: string;
  adminPasswordTls: string;
  orgName: string;
  hostName: string;
  port: number;
  caAdminUsername: string;
  caAdminPassword: string;
};

export type UserEnrollmentOrgCA = {
  orgName: string;
  hostName: string;
  port: number;
  caAdminUsername: string;
  caAdminPassword: string;
};

export type NodeUserEnrollment = {
  username: string;
  password: string;
  rcaHostName: string;
  rcaPort: number;
  tlsHostName: string;
  tlsPort: number;
  orgName: string;
  nodeType: NodeType;
  nodeIdentifier: string;
};
