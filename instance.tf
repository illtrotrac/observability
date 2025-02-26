provider "google" {
  project = "splunkadmin-448709"
  region  = "asia-southeast1"
}

data "google_secret_manager_secret_version" "splunk_access_token" {
  secret = "splunk-access-token"
}

resource "google_compute_instance" "splunk_collector" {
  name         = "observability"
  machine_type = "e2-medium"
  zone         = "asia-southeast1-c"

  tags       = ["web-server", "admin-access"]
  depends_on = [google_compute_network.vpc_network]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    SPLUNK_ACCESS_TOKEN = data.google_secret_manager_secret_version.splunk_access_token.secret_data
  }
  metadata_startup_script = file("startup_script.sh")

}

