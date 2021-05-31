data "google_compute_network" "default-network" {
  name = var.default_network_name
  project = data.google_project.default-project.project_id
}

data "google_project" "default-project" {
  project_id = var.project_id
}

#CREATION DU COMPTE MAISON NON FONCTIONNEL
# data "google_compute_default_service_account" "default" {
# }
