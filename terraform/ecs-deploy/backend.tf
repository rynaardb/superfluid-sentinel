terraform {
  backend "s3" {
    bucket         = "rynaardb-terraform-states"
    key            = "superfluid/sentinel-cd.tfstate"
    region         = "eu-central-1"
    encrypt        = "true"
    dynamodb_table = "terraform-state-lock"
  }
}
