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
