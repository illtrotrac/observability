data "google_secret_manager_secret_version" "splunk_access_token" {
  secret = "splunk-access-token"
}
