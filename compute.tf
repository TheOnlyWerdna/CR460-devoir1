resource "google_compute_instance" "chien" {
  name         = "chien"
  machine_type = "f1-micro"
  tags         = ["public"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-dmz.name
    access_config {

    }
  }

  metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"
}

resource "google_compute_health_check" "http-health-check" {
  name        = "http-health-check"
  description = "Health check via http"

  check_interval_sec  = 4
  healthy_threshold   = 5
  unhealthy_threshold = 3
  timeout_sec         = 2

  http_health_check {
    port = 80
  }
}
