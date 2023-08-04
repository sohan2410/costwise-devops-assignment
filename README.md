# costwise-devops-assignment

## Description
This repository contains the Terraform configuration files to provision and manage infrastructure resources on cloud providers. Terraform is an infrastructure-as-code tool that allows us to define and manage our infrastructure in a declarative way.

## Prerequisites
Before using this Terraform configuration, make sure you have the following prerequisites set up:

1. Terraform installed on your local machine. You can download it from the official website: https://www.terraform.io/downloads.html

2. Access credentials for the cloud provider you are planning to use (e.g., AWS, Azure, Google Cloud).

3. Familiarity with the basics of Terraform and cloud provider services you intend to deploy.

## Installation

To use this Terraform configuration, clone this repository to your local machine:

```
https://github.com/sohan2410/costwise-devops-assignment.git
cd costwise-devops-assignment

```

## Usage

1. Initialize the Terraform project:
Initializes a Terraform working directory by downloading and installing any required provider plugins and modules. This command should be run first in a new project or after adding new providers or modules to an existing project.
```sh
terraform init
```
2. Review the execution plan:
Creates an execution plan that shows what actions Terraform will take to achieve the desired state as defined in your configuration files. It helps you to understand what resources will be created, modified, or deleted without actually executing those changes.
```sh
terraform plan
```
3. Apply the changes:
Applies the changes specified in your Terraform configuration to your infrastructure. It creates, modifies, or deletes resources as needed to achieve the desired state.
```sh
terraform apply
```
4. Terraform destroy:
Destroys all the resources that were created by the Terraform configuration. This command should be used with caution as it can result in data loss.
```sh
terraform destroy
```
