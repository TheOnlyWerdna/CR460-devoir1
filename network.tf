resource "google_compute_network" "devoir1" {
  name                    = var.default_network_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "prod-interne" {
  name          = "prod-interne"
  ip_cidr_range = "172.16.20.0/24"
  region        = "us-east1"
  network       = google_compute_network.devoir1.self_link
}

resource "google_compute_subnetwork" "prod-dmz" {
  name          = "prod-dmz"
  ip_cidr_range = "192.168.65.0/24"
  network       = google_compute_network.devoir1.self_link
  region        = "us-east1"
}

resource "google_compute_subnetwork" "prod-traitement" {
  name          = "prod-traitement"
  ip_cidr_range = "10.0.128.0/24"
  region        = "us-east1"
  network       = google_compute_network.devoir1.self_link
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.devoir1.name

  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }
  target_tags=["http-server"]
}

resource "google_compute_firewall" "firewall-public-web" {
  name    = "firewall-public-web"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_tags=["public-web"]
}

resource "google_compute_firewall" "firewall-prod-interne" {
  name    = "firewall-prod-interne"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["4444", "5126"]
  }

  target_tags = ["traitement"]
  source_tags = ["prod-interne"]
}

resource "google_compute_firewall" "firewall-ssh-interne" {
  name    = "firewall-ssh-interne"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["interne"]
}
