resource "google_iam_workload_identity_pool" "example" {
  workload_identity_pool_id = var.pool_id
  project                   = var.project_id
  display_name              = var.pool_display_name
  description               = var.pool_description
  disabled                  = var.pool_disabled
}

resource "google_iam_workload_identity_pool_provider" "example" {
  for_each                           = { for i in var.wif_providers : i.provider_id => i }
  workload_identity_pool_id          = google_iam_workload_identity_pool.example.workload_identity_pool_id
  workload_identity_pool_provider_id = each.value.provider_id
  project                            = var.project_id
  display_name                       = lookup(each.value, "display_name", null)
  description                        = lookup(each.value, "description", null)
  disabled                           = lookup(each.value, "disabled", false)
  attribute_condition                = lookup(each.value, "attribute_condition", null)
  attribute_mapping                  = lookup(each.value, "attribute_mapping", null) == null ? null : each.value.attribute_mapping

  dynamic "aws" {
    for_each = lookup(each.value, "select_provider", null) == "aws" ? ["1"] : []
    content {
      account_id = each.value.provider_config.account_id
    }
  }
  dynamic "oidc" {
    for_each = lookup(each.value, "select_provider", null) == "oidc" ? ["1"] : []
    content {
      issuer_uri        = each.value.provider_config.issuer_uri
      allowed_audiences = lookup(each.value.provider_config, "allowed_audiences", null) == null ? null : split(",", each.value.provider_config.allowed_audiences)
      jwks_json         = lookup(each.value.provider_config, "jwks_json", null)
    }
  }

}

resource "google_service_account" "service_account" {
  for_each   = toset([for sa_name in var.service_accounts : sa_name.name])
  account_id = each.value
  project    = var.project_id
}


resource "google_service_account_iam_member" "member" {
  for_each = { for account in var.service_accounts : account.name => account }

  service_account_id = google_service_account.service_account[each.value.name].name
  member             = "${each.value.all_identities == false ? "principal" : "principalSet"}://iam.googleapis.com/${google_iam_workload_identity_pool.example.name}/${each.value.attribute}"
  role               = "roles/iam.workloadIdentityUser"
}


resource "google_project_iam_member" "project" {
  for_each = toset(distinct(flatten([for sa in var.service_accounts : [for role in sa.roles : "${sa.name}=>${role}"]])))
  project  = var.project_id
  role     = split("=>", each.value).1
  member   = "serviceAccount:${google_service_account.service_account[split("=>", each.value).0].email}"
}
