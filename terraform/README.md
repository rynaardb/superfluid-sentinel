# Terraform Deployments

## Prerequisites

- AWS cli with configured credentials
- Terraform cli

## container-registry

Contains all the Terraform files for creating and setting up the container registry on AWS ECR.

> NOTE: This is a prerequisite for the `ecs-deploy.yml` GitHub Action workflow.

### Usage

Initialize Terraform:

`terraform init`

Verify resources:

`terraform plan`

Apply the changes:

`terraform apply`

Discard resources:

`terraform destroy`

## ecs-deploy

Contains all the Terraform files required by the `ecs-deploy.yml` GitHub Action workflow.

The workflow is configure to deploy the `sentinel` container to AWS ECS on every commit to `master`.

### Workflow Breakdown

- Build, tag, and push the Docker image on every commit to the `master` branch to AWS ECR
- Run Terraform to create the following resources on AWS:
    - VPC
    - Security Group
    - ECS Cluser
    - ECS Service
    - ECS Task Definition
    - ECS Task Execution Policy
    - EFS Volume to persist the SQLite database

> NOTE: The Terraform state is stored in a AWS S3 to add support for better collaboration, version control, and security.
