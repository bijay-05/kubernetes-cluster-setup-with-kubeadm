terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  backend "s3" {
    bucket = ""
    key = ""
    region = ""
    profile = ""
    use_lockfile = true
  }
  
  required_version = ">= 1.1.0"
}

provider "azurerm" {
    features {}
} 