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

resource "google_compute_firewall" "public-web" {
  name    = "public-web"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  target_tags=["public-web"]
}

resource "google_compute_firewall" "traitement" {
  name    = "traitement"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["4444", "5126"]
  }
  target_tags=["traitement"]
}

resource "google_compute_firewall" "ssh-public" {
  name    = "ssh-public"
  network = google_compute_network.devoir1.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags=["interne"]
}
