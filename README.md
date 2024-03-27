# Terraform Configuration: ec2-create-attach 

This Terraform configuration is designed to automate the provisioning of EC2 instances with attached EBS volumes. It leverages Jinja templates to dynamically generate configurations based on input data.

## Overview

This Terraform setup is an extension of the `ec2-storage-automation` repository. It introduces the use of dynamic `ebs_block_device` to allow for the creation of an Ansible inventory file from a single `apply` command. 

## Features

- Automates the provisioning of EC2 instances with attached EBS volumes.
- Utilizes Jinja templates to generate dynamic configurations.
- Enables the creation of an Ansible inventory file during Terraform apply.

## Prerequisites

- Terraform version 1.7.2 or above.
- Terraform provider `jinja` version 2.2.0 or above.

## Usage

1. Clone the repository to your local machine.
2. Ensure you have the required Terraform version and providers installed.
3. Customize the `data.yaml` file to define your EC2 instances, settings, and EBS volumes.
4. Run `terraform init` to initialize the Terraform configuration.
5. Run `terraform apply` to provision the infrastructure and generate the Ansible inventory file (`inventory.ini`).

## Directory Structure

- `data.yaml`: Input data file containing configurations for EC2 instances and EBS volumes.
- `templates/`: Directory containing Jinja templates used for generating configurations.
- `main.tf`: Main Terraform configuration file defining resources and provisioning logic.

## Usage with Ansible

This Terraform configuration is intended to be used in conjunction with the Ansible playbook provided in the `ansible-disks-mount` repository. After provisioning the infrastructure using Terraform and generating the Ansible inventory file, use the Ansible playbook to perform disk partitioning, formatting, and mounting on the EC2 instances.

## Feedback and Contributions

Feedback and contributions are welcome! If you encounter any issues or have suggestions for improvement, please open an issue or submit a pull request on GitHub.

## Credits

This Terraform configuration is based on the `ec2-storage-automation` repository and extends its functionality to provide enhanced automation capabilities.
