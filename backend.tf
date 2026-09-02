terraform {
  backend "gcs" {
    bucket = "anak-platipus-1-tfstate"
    prefix = "apps"
  }
}
