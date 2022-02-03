locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  # account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  # environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  profile               = local.account_vars.locals.profile
  region                = local.region_vars.locals.region
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "BUCKET_NAME"
    key     = "tf-state/${path_relative_to_include()}/terraform.tfstate"
    region  = "REGION_NAME"
    profile = "PROFILE_NAME"
    encrypt = true
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  profile = "${local.profile}"
  region = "${local.region}"
}
EOF
}

# inputs = merge(
#   local.account_vars.locals,
#   local.region_vars.locals,
#   local.environment_vars.locals,
# )