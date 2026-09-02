terraform {
  experiments = [module_variable_optional_attrs]
  backend "gcs" {
    bucket = "anak-platipus-1-tfstate"
    prefix = "apps"
  }
}
