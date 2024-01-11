module "wif" {
  source = "../"

  project_id = "burner-sudsivam"
  pool_id    = "my-pool-tet"
  wif_providers = [
    { provider_id     = "my-provider-1-t"
      select_provider = "oidc"
      provider_config = {
        issuer_uri        = "https://token.actions.githubusercontent.com"
        allowed_audiences = "https://example.com/gcp-oidc-federation,example.com/gcp-oidc-federation"
        jwks_json         = "{\"keys\":[{\"kty\":\"RSA\",\"alg\":\"RS256\",\"kid\":\"sif0AR-F6MuvksAyAOv-Pds08Bcf2eUMlxE30NofddA\",\"use\":\"sig\",\"e\":\"AQAB\",\"n\":\"ylH1Chl1tpfti3lh51E1g5dPogzXDaQseqjsefGLknaNl5W6Wd4frBhHyE2t41Q5zgz_Ll0-NvWm0FlaG6brhrN9QZu6sJP1bM8WPfJVPgXOanxi7d7TXCkeNubGeiLTf5R3UXtS9Lm_guemU7MxDjDTelxnlgGCihOVTcL526suNJUdfXtpwUsvdU6_ZnAp9IpsuYjCtwPm9hPumlcZGMbxstdh07O4y4O90cVQClJOKSGQjAUCKJWXIQ0cqffGS_HuS_725CPzQ85SzYZzaNpgfhAER7kx_9P16ARM3BJz0PI5fe2hECE61J4GYU_BY43sxDfs7HyJpEXKLU9eWw\"}]}"
      }
      disabled            = false
      attribute_condition = "\"e968c2ef-047c-498d-8d79-16ca1b61e77e\" in assertion.groups"
      attribute_mapping = {
        "attribute.actor"      = "assertion.actor"
        "attribute.repository" = "assertion.repository"
        "google.subject"       = "assertion.sub"
      }
    },
    {
      provider_id     = "my-provider-2-t"
      select_provider = "aws"
      provider_config = {
        account_id = "999999999999"
      }
      disabled            = false
      attribute_condition = "attribute.aws_role==\"arn:aws:sts::999999999999:assumed-role/stack-eu-central-1-lambdaRole\""
      attribute_mapping = {
        "attribute.actor" = "assertion.actor"
        "google.subject"  = "assertion.sub"
      }
    },
    {
      provider_id     = "my-provider-3-t"
      select_provider = "saml"
      provider_config = {
        idp_metadata_xml = "${path.module}/metadata.xml"
      }
      disabled            = false
      attribute_condition = null
      attribute_mapping = {
        "google.subject"        = "assertion.arn"
        "attribute.aws_account" = "assertion.account"
        "attribute.environment" = "assertion.arn.contains(\":instance-profile/Production\") ? \"prod\" : \"test\""
      }
    }
  ]
  service_accounts = [
    {
      name           = "wif-sa-test"
      attribute      = "attribute.repository/my-org/my-repo"
      all_identities = true
      roles          = ["roles/compute.admin"]
    }
  ]
}

