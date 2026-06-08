# Cluster Setup with Terraform Modules

We have wrapped the main terraform source code to create resources in child module `modules/cluster` and are calling it in the root module in the directory. To set up cluster with default variable values ( as defined in the child module variables file ), remove the `variables.tf` and `terraform.tfvars` file in the root directory along with variable nodes in the root `main.tf` file.

> [!Important]
> **Update** : We will use S3 bucket to store terraform state file. This allows us to share infrastructure with other developers along with the flexibility to update infrastructure from remote location. (Since we are no longer bounded by the device and local terraform state file)

We have added `backend {}` block (with S3 bucket configuration) in the `providers.tf` file. You will need to create a file `state.config` with following variables:

```config
bucket = "random-tf-state-bucket"
key = "terraform.tfstate"
region = "ap-south-1"
profile = "default"
```

After this re-initialization is required, so run the following command:

```bash
terraform init -backend-state="./state.config"

```
