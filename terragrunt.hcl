remote_state {
  backend = "s3"

  config = {
    bucket  = "tf-state-761774289685"
    key     = "tf-state/${path_relative_to_include()}/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-tfstate"
  }
}
