# Terraform Beginner Bootcamp 2023 - Week 1

- [Terraform Beginner Bootcamp 2023 - Week 1](#terraform-beginner-bootcamp-2023---week-1)
  * [Fixing tags](#fixing-tags)
  * [Root Module Structure](#root-module-structure)
  * [Terraform and Input Variables](#terraform-and-input-variables)
    + [Terraform Cloud Variables](#terraform-cloud-variables)
    + [Loading Terraform Input Variables](#loading-terraform-input-variables)
    + [var-file flag](#var-file-flag)
    + [terraform.tfvars](#terraformtfvars)
    + [auto.tfvars](#autotfvars)
    + [order of terraform variables](#order-of-terraform-variables)
  * [Terraform Import](#terraform-import)
  * [Dealing With Configuration Drift](#dealing-with-configuration-drift)
    + [What happens if we lose our state file?](#what-happens-if-we-lose-our-state-file-)
    + [Fix missing resources with Terraform Import](#fix-missing-resources-with-terraform-import)
    + [Fix manual configuration](#fix-manual-configuration)
  * [Fix using Terraform Refresh](#fix-using-terraform-refresh)
  * [Terraform Modules](#terraform-modules)
    + [Terraform Module Structure](#terraform-module-structure)
    + [Passing Input Variables](#passing-input-variables)
    + [Module Sources](#module-sources)
  * [Considerations when using ChatGPT to write Terraform](#considerations-when-using-chatgpt-to-write-terraform)
  * [Working with files in Terraform](#working-with-files-in-terraform)
    + [Fileexists function](#fileexists-function)
    + [Filemd5](#filemd5)
    + [Path Variable](#path-variable)
- [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object](#https---registryterraformio-providers-hashicorp-aws-latest-docs-resources-s3-object)
  * [Terraform Locals](#terraform-locals)
    + [Terraform Data Sources](#terraform-data-sources)
  * [Working with JSON](#working-with-json)
    + [Changing the Lifecycle of Resources](#changing-the-lifecycle-of-resources)
  * [Terraform Data](#terraform-data)
  * [Provisioners](#provisioners)
    + [Local-exec](#local-exec)
    + [Remote-exec](#remote-exec)
  * [For Each Expressions](#for-each-expressions)

## Fixing tags

Locally Delete a Tag

```bash
git tag -d <tag_name>
```

Remotely delete a tag

```bash
git push --delete origin tagname
```

Checkout the commit you want to retag. Grab the sha from your github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

[How to Delete Local and Remote Tags in GitHub](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

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

## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing modules, but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module. The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

Using the source, we can import the module from various places e.g.
- locally
- Github
- Terraform Registry

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT ay not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. This may especially affect provider configuration.

## Working with files in Terraform

### Fileexists function

This is a builtin terraform function to check for the existence of a file.

```tf
condition = fileexists(var.error_html_filepath)`
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5

This hashes the contents of a file rather than the filename string.

One usecase is that adding this parameter to the resource allows terraform to recognise if the file contents have changed, and apply the updated file.

```tf
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key = "index.html"
  source = "${path.root}/public/index.html"
  etag = filemd5("${path.root}/public/index.html")
}
```

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In Terraform there is a special variable called `path` that allows us to reference local paths.

- path.module
- path.root

[Working with Files in Terraform](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key = "index.html"
  source = "${path.root}/public/index.html"
}

## Terraform Locals

Locals allow us to define local variables. 

It can be useful when we want to transform data to another format and have it referenced as a variable.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows us to source data from cloud resources.

This is useful when we want to reference cloud services without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-cloudfront-introduces-origin-access-control-oac/

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Changing the Lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

The terraform_data resource is useful for storing values which need to follow a manage resource lifecycle, and for triggering provisioners when there is no other logical managed resource in which to place them.

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

```tf
resource "terraform_data" "content_version" {
  input = var.content_version
}
```

[Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners

Provisioners allow you to execute commands on compute instances e.g. an AWS CLI Command.

They are not recommended for use by Hashicorp because configuration management tools like Ansible are a better fit, but the functionality exists.

```tf
<<EOT
hello
world
EOT
```

### Local-exec

This will execute commands on a machine running the terraform commands e.g. plan or apply.

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}

```

[local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as SSH to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

[remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)


[heredoc strings](https://developer.hashicorp.com/terraform/language/expressions/strings#heredoc-strings)

[Provisioners are a last resort](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#provisioners-are-a-last-resort)

## For Each Expressions

For Each allows us to enumerate over complex data types.

```sh
[for s in var.list : upp(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive code.
[For Each Expressions](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

https://developer.hashicorp.com/terraform/language/functions/fileset
