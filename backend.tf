terraform {
  backend "remote" {
    organization = "vtl-aks"

    workspaces {
      name = "vtl-aks-dev"
    }
  }
}
