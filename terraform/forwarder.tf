resource "google_compute_instance" "forwarder_vm" {
  name         = "splunk_forwarder"
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

  metadata_startup_script = <<-EOT
    echo '${file("../config/agent_config.yaml")}' | sudo tee /etc/otel/agent_config.yaml > /dev/null
  EOT
}


