resource "duplocloud_tenant_access_grant" "this" {
  for_each = {
    for grant in var.grants : "${coalesce(grant.grantee, "parent")}-${grant.area}" => {
      grant_area        = grant.area
      grantor_tenant_id = grant.grantee == null ? local.parent.id : local.tenant_id
      grantee_tenant_id = grant.grantee == null ? local.tenant_id : data.duplocloud_tenant.siblings[grant.grantee].id
    }
  }
  grantor_tenant_id = each.value.grantor_tenant_id
  grantee_tenant_id = each.value.grantee_tenant_id
  grant_area        = each.value.grant_area
}
