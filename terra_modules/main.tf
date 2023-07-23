# main.tf

module "usermodule" {
  source = "./modules"
  environment = "DEV"
}