# Terraform Beginner Bootcamp 2023 - Week 2

## Terratowns Mock Server

### Running the Web Server

We can run the web server by executing the following commands

All of our code for our server is stored in the [server.rb](./terratowns_mock_server/server.rb) file.

We have installed the Terratowns Mock Server to help speed up development.

### How to Install

The repo is already installed, but here are the instructions for how to do this again if needed:

- Clone the repo into the top-level directory of the project [Terratowns Mock Server](https://github.com/ExamProCo/terratowns_mock_server)
- (Make sure you are in the correct folder!) Remove the `.git` folder from the [./terratowns_mock_server](./terratowns_mock_server) folder using `rm -rf .git`
- Rename the `/bin` folder in the [./terratowns_mock_server](./terratowns_mock_server) to `terratowns`
- Move the new `terratowns` folder from the mock server folder to the project [./bin](./bin) folder

## Working with Ruby

### Bundler

Bundler is a package manager for Ruby. It is the primary way to install Ruby packages (known as gems) for Ruby.

#### Install Gems

You need to create a Gemfile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command.

This will install the gems on the system globally (unlike nodejs which installs the packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versions used in this project.

#### Executing scripts in the context of Bundler

We have to use `bundle exec` to tell future Ruby scripts to use the gems we installed. This is the way we set context.

#### Sinatra

Sinatra is a micro web-framework for Ruby to build web-apps.

It;s great for mock or development servers, or for very simple projects.

You can create a web-server in a single file.

[Sinatra Web Server](https://sinatrarb.com/)


https://www.hashicorp.com/blog/writing-custom-terraform-providers