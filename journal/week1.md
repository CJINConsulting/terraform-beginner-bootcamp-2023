# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

The root module structure is as follows:
```
- PROJECT_ROOT
    |-- main.tf            # everything else
    |-- variables.tf       # stores the structure of input variables

    |-- providers.tf       # defines required providers and their configuration
    |-- outputs.tf         # stores our outputs
    |-- terraform.tfvars   # the variable data we want to load into our project
    |-- README.md          # required for root modules
```

[Root Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In Terraform Cloud we can set two kinds of variables:
- Environment Variables - those you would normally set in your bash terminal e.g. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

We can use the `-var` flag to set an input variable or ovveride a variable in the tfvars file e.g. `terraform -var user_id="my_user_id"`

### var-file flag

We can use the `-var-file` flag to pass a variable file that contains values some or all of your Terraform variables. 

This flag allows you to separate your variables from your main Terraform configuration files, allowing you to manage and reuse configuration across different environments.

e.g.
```
# my-variables.tfvars

region = "us-west-2"
instance_type = "t2.micro"
```

https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files

### terraform.tfvars

This is the default file to load in terraform variables in bulk.

### auto.tfvars

This is the default version of the `-var-file`. Terraform automatically looks for this file on a plan and apply without the need to specify the `-var-file` flag.

### order of terraform variables

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence

## Terraform Import

## Dealing With Configuration Drift

### What happens if we lose our state file?

If you lost your statefile, you will most likely have to teardown all of your infrastructure manually.

You can use terraform import, but it won't work for all resources. You need to check the terraform providers documentation to see which resources suppport import.

### Fix missing resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket_name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)

### Fix manual configuration

This may be needed if someone manually modifies the cloud resources manually through ClickOps.

If we run `terraform plan` it will attempt to put our infrastructure back into the expected state fixing Configuration Drift.