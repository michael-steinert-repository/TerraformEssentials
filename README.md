# Terraform

- Terraform is a version-controlled Infrastructure as Code Tool that allows to model Cloud Infrastructure through Code
- It works in a declarative Manner - so the Code is the Blueprint and Terraform build the corresponding Infrastructure
- Infrastructure as Code (IaC) is the Process of Managing and Deploying Infrastructure using Machine-readable Definition Files
- Terraform is an immutable and declarative Provisioning Language based on HashiCorp's Configuration Language (HCL) or optionally JSON
- It can manage low-level Components such as Compute, Storage and Network Resources, as well as high-level Components such as DNS Records and SaaS Features
- It is designed to work with almost any Cloud Infrastructure that provides an API, making it a Agent-less and cloud-agnostic Tool that is not tied to a single Cloud Provider

## Advantages of Terraform

- Terraform provides Configuration consistency and Standardization for Deployments
- It is easy to learn and write because it is more like Configuration than Development of Code
- It allows Developers to turn manual Tasks into simple automated Deployments
- Developers can create reusable Modules for easy Sharing and Collaboration and safely modify existing Infrastructure by using a Dry Run before applying Changes
- Terraform can be integrated with current Application Cl/CD Workflow Pipelines for more mature automated Deployments
- It is consistent, repeatable, idempotent and predictable, and allowing Developers to recreate an Application's Infrastructure for Disaster Recovery

## Advantages State

- Terraform is a stateful Application
- The State is a Database that allows Terraform to map its Configuration to the Cloud Infrastructure

## Terraform Files

- The following Command formats all Terraform Files

```bash
terraform fmt
```

- The following Command validates all Terraform Files

```bash
terraform validate
```

- The following Command runes a Dry Run and shows all the Cloud Resources that Terraform will provision

```bash
terraform plan
```

### main.tf

```terraform
provider "docker" {}

resource "docker_image" "my_image" {
  name = "${var.image_name}:${var.image_tag}"
}

resource "docker_container" "my_container" {
  name = var.my_container_name
  image = docker_image.my_image.image_id
  ports {
    internal = 80
    external = 8080
  }
}
```

- A `resource` Block creates Cloud Resources and a `data` Block get some Data from the Cloud Resource like an ID from a Cloud Resource
- Creates the corresponding Cloud Resources

```bash
terraform init
terraform plan
terraform apply
```

- Destroys the corresponding Cloud Resources

```bash
terraform destroy
```

### variables.tf

- `variables.tf` contains the default Variables that can be used in all Terraform Files

```terraform
variable "image_name" {
  default = "nginx"
}
variable "image_tag" {
  default = "1.23.3"
}
variable "my_container_name" {
  type = string
  description = "Default Name of Container"
  default = "DefaultName"
}
```

### terraform.tfvars

```terraform
image_name = "nginx"
image_tag  = "1.23.4"
```

- Contains the concrete Assignments for the Variables that can be used in all Terraform Files

### outputs.tf

```terraform
output "MY_CONTAINER_NAME" {
  value = var.my_container_name
}
```

- `outputs.tf` outputs all Variables that that are in the `outputs.tf` declared

```bash
terraform output
```

- The following Command allows to print an Output from Terraform to the Terminal

```bash
cat $(terraform output -raw MY_CONTAINER_NAME)
```

<hr>

## Terraform Architecture

<p align="center">
  <img src="https://user-images.githubusercontent.com/29623199/136066627-8a6a6f6c-c3dd-4df2-b60b-dfe5f7306d70.png" alt="Terraform Architecture" width="100%"/>
</P>

<hr>
  
## Terraform Files

- `terraform.tfstate` contains the current State of Terraform and historical Data of all Resources that were created by Terraform

| Command                          | Description                                                                                                                                         |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| **terraform**                    |                                                                                                                                                     |
| terraform init                   | Terraform searchs all Cloud Providers from the Configurations (Files that ends with .tf), and downloads the Plugins to interact with the Cloud APIs |
| terraform plan                   | Terraform shows to see Changes that are required for current Infrastructure                                                                         |
| terraform apply                  | Terraform applys all Changes that are required for current Infrastructure                                                                           |
| terraform destroy                | Terraform deletes all Services that was created by Terraform                                                                                        |
|                                  |                                                                                                                                                     |
| **terraform state**              |                                                                                                                                                     |
| terraform state list             | List Resources in the State                                                                                                                         |
| terraform state mv               | Move an Item in the State                                                                                                                           |
| terraform state pull             | Pull current State and output to Stdout                                                                                                             |
| terraform state push             | Update remote State from a local State File                                                                                                         |
| terraform state replace-provider | Replace Provider in the State                                                                                                                       |
| terraform state rm               | Remove Instances from the State                                                                                                                     |
| terraform state show             | Show a Resource in the State                                                                                                                        |
