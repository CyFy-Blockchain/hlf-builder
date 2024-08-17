import { OrgCaConfigs } from "../interfaces/org-ca";
import { initializeOrganizationCA, updateOrganizationCA } from "../lib/org-ca";

export async function initOrgCa(orgConfig: OrgCaConfigs) {
  await initializeOrganizationCA(orgConfig);
  updateOrganizationCA(orgConfig);
}
