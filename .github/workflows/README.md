# GitHub Actions Workflows for Terraform and Fly.io

This directory contains GitHub Actions workflows for automating the deployment of Terraform configurations to Fly.io.

## Available Workflows

### 1. PR Validation Workflow (`terraform-pr.yml`)

This workflow runs on pull requests that modify files in the `terraform/` directory. It performs:
- Terraform format check
- Terraform validation
- Plan generation for dev and docker-compose-dev environments
- Posts the results as a comment on the pull request

### 2. Deployment Workflow (`terraform-deploy.yml`)

This workflow runs when changes are pushed to the `main`, `develop`, or `staging` branches. It:
- Determines the target environment based on the branch
- Deploys the Terraform configuration to the appropriate Fly.io environment
- Optionally deploys the Docker Compose configuration if triggered

### 3. Manual Deployment Workflow (`terraform-manual.yml`)

This workflow can be manually triggered from the GitHub Actions UI. It allows you to:
- Select which environment to deploy to (dev, staging, prod, or docker-compose-dev)
- Choose the action to perform (plan, apply, or destroy)
- Execute the deployment with a single click

## Required Secrets

You need to set up the following secrets in your GitHub repository:

| Secret Name | Description |
|-------------|-------------|
| `FLY_API_TOKEN` | Your Fly.io API token for authentication |
| `TF_API_TOKEN` | (Optional) Terraform Cloud API token if using Terraform Cloud |

### Setting up Secrets

1. In your GitHub repository, go to **Settings** > **Secrets and variables** > **Actions**
2. Click on **New repository secret**
3. Add each secret with its corresponding value

## Environment Setup

The deployment workflow uses GitHub Environments for deployment protection and secrets isolation.

You should create the following environments in your repository settings:

1. `dev` - For the development environment
2. `staging` - For the staging environment
3. `prod` - For the production environment
4. `docker-compose` - For Docker Compose deployments

For each environment, you can configure:
- Environment-specific secrets
- Required reviewers
- Deployment protection rules

## Deployment Triggers

- Changes to the `develop` branch deploy to the `dev` environment
- Changes to the `staging` branch deploy to the `staging` environment
- Changes to the `main` branch deploy to the `prod` environment
- Docker Compose deployment is triggered either by:
  - Including `deploy-docker` in the commit message
  - Modifying files containing `compose` in their name

## Manual Triggering

You can manually trigger deployments through the GitHub Actions UI:

1. Navigate to the **Actions** tab in your repository
2. Select the **Manual Terraform Deployment** workflow
3. Click on **Run workflow**
4. Choose the environment and action from the dropdown menus
5. Click **Run workflow** to start the deployment

This is especially useful for:
- Running plans before making changes
- Deploying to specific environments without pushing code
- Destroying resources when they are no longer needed 