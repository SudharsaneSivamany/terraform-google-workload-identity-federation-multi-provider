# GCP Worload Identity Federation Multi Provider Module
The Workload identity federation module is used to impersonate a gcp service account from the credentials issued by an external identity provider and access resources on Google Cloud. 
This module will create pool,providers(aws/oidc)and service account used for setting up workload identity federation.
## Roles Needed

* roles/iam.workloadIdentityPoolAdmin
* roles/iam.serviceAccountAdmin


## Enable Apis and Services
* cloudresourcemanager.googleapis.com
* iam.googleapis.com
* iamcredentials.googleapis.com
* sts.googleapis.com


## Sample Usage
```hcl

module "wif" {
  source     = "SudharsaneSivamany/workload-identity-federation-multi-provider/google"

  project_id = "my-project"
  pool_id    = "my-pool"
  wif_providers = [
  { provider_id          = "my-provider-1"
    select_provider      = "oidc"
    provider_config      = {
                             issuer_uri = "https://token.actions.githubusercontent.com"
                             allowed_audiences = "https://example.com/gcp-oidc-federation,example.com/gcp-oidc-federation" 
                           }
    disabled             = false
    attribute_condition  = "\"e968c2ef-047c-498d-8d79-16ca1b61e77e\" in assertion.groups"
    attribute_mapping    = {
                             "attribute.actor"      = "assertion.actor"
                             "attribute.repository" = "assertion.repository"
                             "google.subject"       = "assertion.sub"
                           } 
  },
  {
    provider_id          = "my-provider-2"
    select_provider      = "aws"
    provider_config      = {
                             account_id = "999999999999"
                           }
    disabled             = false
    attribute_condition  = "attribute.aws_role==\"arn:aws:sts::999999999999:assumed-role/stack-eu-central-1-lambdaRole\""
    attribute_mapping    = {
                             "attribute.actor" = "assertion.actor"
                             "google.subject"  = "assertion.sub"
                           }
  }
]
  service_accounts = [
    {
      name           = "wif-sa-1"
      attribute      = "attribute.repository/my-org/my-repo"
      all_identities = true
      roles          = ["roles/compute.admin"]
    }
  ]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.45, < 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.45, < 5.0.0 |


## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.example](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.example](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pool_description"></a> [pool\_description](#input\_pool\_description) | n/a | `string` | `null` | no |
| <a name="input_pool_disabled"></a> [pool\_disabled](#input\_pool\_disabled) | n/a | `bool` | `false` | no |
| <a name="input_pool_display_name"></a> [pool\_display\_name](#input\_pool\_display\_name) | n/a | `string` | `null` | no |
| <a name="input_pool_id"></a> [pool\_id](#input\_pool\_id) | n/a | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | n/a | <pre>list(object({<br>    name           = string<br>    attribute      = string<br>    all_identities = bool<br>    roles = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_wif_providers"></a> [wif\_providers](#input\_wif\_providers) | n/a | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pool_id"></a> [pool\_id](#output\_pool\_id) | Pool id |
| <a name="output_pool_name"></a> [pool\_name](#output\_pool\_name) | Pool name |
| <a name="output_pool_state"></a> [pool\_state](#output\_pool\_state) | Pool state |
| <a name="output_provider_id"></a> [provider\_id](#output\_provider\_id) | Provider id |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service Account name |
