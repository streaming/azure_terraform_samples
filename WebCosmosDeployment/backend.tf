# Specify Azure blob storage backend for state management
terraform {
  backend "azurerm" {
    storage_account_name = "#{AzureStorageAccountName}"
    container_name       = "#{AzureStorageContainerName}"
    key                  = "terraform.#{Environment}.#{Octopus.Project.Name}.tfstate"
    access_key           = "#{AzureAccessKey}"
  }
}
