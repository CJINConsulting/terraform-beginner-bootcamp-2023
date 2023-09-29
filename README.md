# Terraform Beginner Bootcamp 2023

## Table of Contents

- [Semantic Versioning](#semantic-versioning-%EF%B8%8F)
- [Install the Terraform CLI](#install-the-terraform-cli)
    - [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
    - [Considerations for Linux distibution](#considerations-for-linux-distibution)
    - [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
- [GitPod Lifecycle (Before, Init, Command)](#gitpod-lifecycle-before-init-command)
- [Working with Env Vars](#working-with-env-vars)
    - [Setting and unsetting Env Vars](#setting-and-unsetting-env-vars)
    - [Printing Vars](#printing-vars)
    - [Scoping of Env Vars](#scoping-of-env-vars)
    - [Persisting Env Vars in GitPod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
    - [Terraform Registry](#terraform-registry)
    - [Terraform Console](d#terraform-console)
    - [Terraform Lock Files](#terraform-lock-files)
    - [Terraform State Files](#terraform-state-files)
    - [Terraform Directory](#terraform-directory)
- [AWS](#aws)
    - [S3 Bucket](#s3-bucket)
- [Issues with Terraform Cloud Login and GitPod Workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)
    - [Terraform Cloud variables also need setting](#terraform-cloud-variables-also-need-setting)

# Semantic Versioning 🧙‍♂️
This project is going to utilise semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, e.g. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation steps have changed due to gpg keyring changes. So we needed to refer to the latest install CLI instructions via Terraform documentation and change the scripting for install.

[Install the Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux distibution
This project is built against ubuntu. Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How to check OS version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version
```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg deprecation issues, we noticed the new steps were quite long. We created a new Terraform CLI bash script to install the Terraform CLI.

This bash script is created in the [bin folder](./bin/install_terraform_cli)
- This will keep the GitPod Task File ([.gitpod.yml](.gitpod.yml)) tidy
- This will allow us to more easily debug and execute manual Terraform CLI installs
- This will allow better portability for other projects that need to install Terraform CLI.

#### Shebang

A Shebang (pronounced Sha-bang) tells the bash script what program will interpret the script. e.g. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- for portability on different OS distributions
- will search user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the ash script we can use the `./` shorthand notification to execute the bash script.

e.g. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml, we need to point the script to a program to interpret it.

e.g. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be executable at the user level.

```sh
chmod u+x ./bin/install_terraform_cli
```

We could also alternatively do this:

``` sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

### GitPod Lifecycle (Before, Init, Command)

We need to be careful when using the init, because it will not re-run if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks#prebuild-and-new-workspaces

## Working with Env Vars

We can list out all Environment Variables using the `env` command.

We can filter specific env vars using grep e.g. `env | grep AWS_`

### Setting and unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export e.g.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Printing Vars

We can print an env var using eho e.g. `echo $HELLO`

#### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. e.g. `.bash_profile`

#### Persisting Env Vars in GitPod

We can persist env vars into GitPod by storing them in GitPod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.

### AWS CLI Installation

AWS CLI is installed for this project. You need to set specific env vars via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is successful, you should get a json payload return that looks something like this:

```json
{
    "UserId": "BJEB1ZTXWEUAABRBUFG2L",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/colin.piper"
}
```

We'll need to generate AWS CLI credentials from IAM user in order to use the AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources the providers and modules from the Terraform Registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** are plugins that enable Terraform to interact with an API.
- **Modules** are a way to refactor terraform code to make it more modular, portable and shareable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the terraform commands by simply typing `terraform`.

#### Terraform Init

`terraform init`

At the start of a new terraform project we run `terraform init` to download the binaries for the providers in this project.

#### Terraform Plan

`terraform plan`

This will generate a 'changeset' about the state of our infrastructure, and what will be changed. We can output this changeset to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt 'yes' or 'no'.

If we want to automatically approve an apply we can provide the auto-approve flag e.g. `terraform apply --auto-approve`

#### Terraform Destroy

`terraform destroy`

This will destroy all resources.

If we want to automatically destroy we can provide the auto-approve flag e.g. `terraform destroy --auto-approve`

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform lock file should be committed to you Version Control System (VCS) e.g. Github.

### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be committed** to your VCS.

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state prior to the new one.

### Terraform Directory

`.terraform` directory contains binaries for the providers.

## AWS

### S3 Bucket

#### Naming Conventions

When creating new buckets, double-check the rules around naming conventions.

[Bucket Naming Rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html)

## Issues with Terraform Cloud Login and GitPod Workspace

When attempting to run `terraform login` it will launch a view in the terminal to generate a token. However it doesn't work as expected in GitPod VSCode in the browser.

Workaround is to manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens
```

Copy the key value created.

Run `terraform login`, press `q` to quit, then enter your copied at the token prompt.

We have automated the process with the following bash script [bin/generate_tfrc_credentials](bin/generate_tfrc_credentials)

### Terraform Cloud variables also need setting

After migrating to Terraform Cloud, you may get a similar error when running the `terraform plan`:
```
Error: No valid credential sources found
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 33, in provider "aws":
│   33: provider "aws" {
│ 
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│ 
│ Error: failed to refresh cached credentials, no EC2 IMDS role found,
│ operation error ec2imds: GetMetadata, request canceled, context deadline
│ exceeded
```
The variables stored in the console will also need to be added as environment variables in the Terraform Cloud Platform Variables
- `https://app.terraform.io/app/<your_user_name>/workspaces/<your_workspace_name>/variables`
- Set these to the 'env' category or else they won't be recognised
