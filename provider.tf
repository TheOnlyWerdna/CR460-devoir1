provider "google" {
  project = var.project_id
  credentials = "account.json"
  region  = "us-east1"
  zone    = var.zone
}

#############################################
#CREATION DU COMPTE MAISON NON FONCTIONNEL
###############################################
# resource "google_service_account" "sa" {
#   account_id   = "maison"
#   display_name = "maison"
# }
#
# resource "google_service_account_key" "mykey" {
#   service_account_id = google_service_account.sa.name
#   public_key_type    = "TYPE_X509_PEM_FILE"
# }
#
# resource "google_project_iam_member" "project" {
#   project = var.project_id
#   role    = "roles/viewer"
#   member  = "user:maison@example.com"
# }
#
# resource "google_service_account_iam_member" "viewer-iam" {
#   service_account_id = google_service_account.sa.name
#   role               = "roles/viewer"
#   member             = "user:maison@example.com"
# }
#
# # Allow SA service account use the default GCE account
# resource "google_service_account_iam_member" "gce-default-account-iam" {
#   service_account_id = data.google_compute_default_service_account.default.name
#   role               = "roles/viewer"
#   member             = "serviceAccount:${google_service_account.sa.email}"
# }
