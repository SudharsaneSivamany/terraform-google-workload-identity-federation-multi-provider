mock_provider "google" {
  alias = "fake"
  mock_resource "google_service_account" {
    defaults = {
        name = "projects/project-1/serviceAccounts/wif-sa-test@burner-sudsivam.iam.gserviceaccount.com"
    }
  } 
  mock_resource "google_iam_workload_identity_pool" {
    defaults = {
        name = "my-test-pool"
    }
  }
}

run "mock" {
    providers = {
        google = google.fake
    }
    module {
        source = "./"
    }
    assert {
        condition = module.wif.pool_name == "my-test-pool"
        error_message = "Failed: Mismatch in pool name"
    }
    assert {
        condition = length(module.wif.provider_id) == 3
        error_message = "Failed: Mismatch in provider count"
    }
}