# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

The root module structure is as follows:
- PROJECT_ROOT
    |-- main.tf            # everything else
    |-- variables.tf       # stores the structure of input variables

    |-- providers.tf       # defines required providers and their configuration
    |-- outputs.tf         # stores our outputs
    |-- terraform.tfvars   # the variable data we want to load into our project
    |-- README.md          # required for root modules


[Root Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)