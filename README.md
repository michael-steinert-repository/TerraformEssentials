# Terraform

* Terraform is a Infrastructure-as-Code Tool
* It allows to model Cloud Infrastructure through Code
* It works in a declarative Manner - so the Code is the Blueprint and Terraform build the corresponding Infrastructur
* Code for Terraform is written HashiCorp Configuration Language (HCL)

* With Terraform it is not necessary to learn the underlaying API from the Cloud Providers

## Terraform Architecture

<p align="center">
    <img src="https://user-images.githubusercontent.com/29623199/136066627-8a6a6f6c-c3dd-4df2-b60b-dfe5f7306d70.png" alt="Terraform Architecture" width="100%"/>
</P>

<hr>
  
## Terraform Files

* terraform.tfstate: Contains the current State of Terraform and historical Data of all Resources that were created by Terraform

|Command|Description|
|---|---|
|__terraform__||
|terraform init|Terraform searchs all Cloud Providers from the Configurations (Files that ends with .tf), and downloads the Plugins to interact with the Cloud APIs|
|terraform plan|Terraform shows to see Changes that are required for current Infrastructure|
|terraform apply|Terraform applys all Changes that are required for current Infrastructure|
|terraform destroy|Terraform deletes all Services that was created by Terraform|
|||
|__terraform state__||
terraform state list|List Resources in the State|
terraform state mv|Move an Item in the State|
terraform state pull|Pull current State and output to Stdout|    
terraform state push|Update remote State from a local State File|
terraform state replace-provider|Replace Provider in the State|
terraform state rm|Remove Instances from the State|
terraform state show|Show a Resource in the State|
