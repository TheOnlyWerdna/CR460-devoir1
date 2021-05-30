resource "google_compute_instance" "chien" {
  name         = "chien"
  machine_type = "f1-micro"
  zone         = "us-east1-c"
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

resource "google_compute_instance" "chat" {
  name         = "chat"
  machine_type = "f1-micro"
  zone         = "us-east1-c"
  tags         = ["interne"]

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-interne.name
    access_config {

    }
  }
}

resource "google_compute_instance" "hamster" {
  name         = "hamster"
  machine_type = "f1-micro"
  zone         = "us-east1-c"
  tags         = ["traitement"]

  boot_disk {
    initialize_params {
      image = "fedora-coreos-cloud/fedora-coreos-stable"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-traitement.name
    access_config {

    }
  }
}

resource "google_compute_instance_template" "devoir1-workload-template" {
  name                 = "devoir1-workload-template"
  tags                 = ["workload"]
  machine_type         = "n1-standard-1"
  region               = "us-east1"
  can_ip_forward       = true

  // Create a new boot disk from an image
  disk {
    source_image = "fedora-coreos-cloud/fedora-coreos-stable"
    auto_delete = true
    boot = false
  }

  network_interface {
    subnetwork = google_compute_subnetwork.prod-traitement.name
    access_config {

    }
  }

}

resource "google_compute_instance_group_manager" "devoir1-workload-gm" {
  name        = "devoir1-workload-gm"
  base_instance_name = "worker"
  version {
    instance_template  = google_compute_instance_template.devoir1-workload-template.self_link
    name               = "primary"
  }
  zone               = "us-east1-c"

}

resource "google_compute_autoscaler" "devoir1-autoscaler" {
  name   = "devoir1-autoscaler"
  zone   = "us-east1-c"
  target = google_compute_instance_group_manager.devoir1-workload-gm.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 180

    cpu_utilization {
      target = 0.53
    }
  }
}

# resource "google_compute_instance" "perroquet" {
#   name         = "perroquet"
#   machine_type = "f1-micro"
#   zone         = "us-east1-c"
#   tags         = ["cage"]
#
#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2004-lts"
#     }
#   }
#
#   network_interface {
#     network = data.google_compute_network.devoir1.name
#     access_config {
#
#     }
#   }
#
#   metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"
# }
