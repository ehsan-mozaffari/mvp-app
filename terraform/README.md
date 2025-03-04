# Fly.io Terraform Configuration

This project provides a modular, enterprise-ready Terraform setup for managing infrastructure on Fly.io.

## Structure

```
terraform/
├── modules/                # Reusable Terraform modules
│   ├── fly-app/           # Module for Fly.io application
│   ├── fly-machines/      # Module for Fly.io machines
│   ├── fly-volumes/       # Module for Fly.io volumes
│   └── fly-docker-compose/ # Module for Docker Compose deployment
├── environments/          # Environment-specific configurations
│   ├── dev/               # Development environment
│   ├── staging/           # Staging environment
│   ├── prod/              # Production environment
│   └── docker-compose-dev/ # Docker Compose development environment
├── config/                # Shared configuration files
├── main.tf                # Main Terraform configuration
├── provider.tf            # Provider configuration
├── variables.tf           # Input variables
├── outputs.tf             # Output values
├── deploy.sh              # Deployment script for all environments
├── .envrc.example         # Example environment variables for direnv
└── credentials.tfvars.example  # Example credentials file (do not commit real credentials)
```

## Features

- **Modular Design**: Reusable modules for Fly.io resources
- **Environment Separation**: Isolated configurations for dev, staging, and production
- **Secure Credential Management**: Options for managing API tokens securely
- **Deployment Script**: Simplified deployment across environments
- **Volume Name Compatibility**: Proper formatting for Fly.io volume names
- **Docker Compose Support**: Deploy applications using Docker Compose
- **CI/CD Integration**: GitHub Actions workflows for automated deployments

## Authentication

To authenticate with Fly.io, you need to provide an API token. You can get this from your Fly.io dashboard.

1. Copy the `credentials.tfvars.example` file to `credentials.tfvars`
2. Add your Fly.io API token to the `credentials.tfvars` file
3. Keep this file secure and never commit it to version control

## Usage

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or newer)
- Fly.io account and API token
- (Optional) direnv for environment variable management
- (Optional) flyctl for Docker Compose deployments

### Running Terraform

#### Using the Deployment Script:

The easiest way to deploy is using the provided script:

```bash
# Make the script executable (first time only)
chmod +x deploy.sh

# Deploy to development environment
./deploy.sh dev plan  # To see changes
./deploy.sh dev apply # To apply changes

# Deploy to staging or production
./deploy.sh staging apply
./deploy.sh prod apply

# For Docker Compose deployment
./deploy.sh docker-compose-dev apply
```

#### Manual Deployment:

1. Navigate to the environment directory you want to deploy:
   ```
   cd terraform/environments/dev
   ```

2. Copy the credentials example file and fill in your API token:
   ```
   cp credentials.tfvars.example credentials.tfvars
   # Edit credentials.tfvars to add your Fly.io API token
   ```

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Plan changes:
   ```
   terraform plan -var-file=credentials.tfvars
   ```

5. Apply changes:
   ```
   terraform apply -var-file=credentials.tfvars
   ```

### Using Environment Variables (Alternative)

Instead of using tfvars files, you can use environment variables:

1. If using direnv, copy the .envrc.example file:
   ```
   cp .envrc.example .envrc
   ```

2. Edit the .envrc file to add your Fly.io API token:
   ```
   export FLY_API_TOKEN="your_fly_api_token_here"
   ```

3. Allow direnv to load the environment:
   ```
   direnv allow
   ```

4. Use the deployment script or run Terraform directly:
   ```
   ./deploy.sh dev plan
   ```

### GitHub Actions CI/CD

This project includes GitHub Actions workflows for automated validation and deployment:

1. **PR Validation**: Automatically runs on pull requests to validate your Terraform changes
2. **Environment Deployment**: Automatically deploys to the appropriate environment based on the branch:
   - `develop` branch → `dev` environment
   - `staging` branch → `staging` environment
   - `main` branch → `prod` environment
   - Docker Compose deployments can be triggered via commit message

For more details, see the [GitHub Actions workflows README](../.github/workflows/README.md).

### Environment-Specific Configuration

Each environment (dev, staging, prod) has its own configuration with appropriate settings:

- **Dev**: Single region, minimal resources for testing
- **Staging**: Two regions, moderate resources for testing
- **Production**: Three regions, production-grade resources
- **Docker Compose Dev**: Single region deployment using Docker Compose

## Modules

### fly-app

Creates a Fly.io application.

### fly-machines

Creates Fly.io machines (VMs) in the specified regions.

### fly-volumes

Creates persistent volumes for the Fly.io machines.

### fly-docker-compose

Deploys applications using Docker Compose, with the following features:
- Creates Fly.io application, machines, and volumes in one module
- Uploads HTML content to volumes using flyctl
- Configures machines to serve the content

## Docker Compose Deployment

To deploy using Docker Compose:

1. Ensure you have flyctl installed and authenticated
2. Navigate to the Docker Compose environment directory:
   ```
   cd terraform/environments/docker-compose-dev
   ```
3. Follow the same deployment steps as above.

The Docker Compose deployment will:
1. Create a Fly.io application
2. Create volumes for your HTML content
3. Deploy machines with the nginx image
4. Upload your HTML content to the volumes
5. Configure the machines to serve the content

## Customization

You can customize the configuration by modifying the `variables.tf` files or by overriding values in the environment-specific files.

## Troubleshooting

### Provider Configuration

If you encounter provider-related errors, ensure that:
- Each module has the correct `required_providers` block
- The provider source is set to `fly-apps/fly` (not `hashicorp/fly`)
- The environment module has a provider configuration with the API token

### Volume Names

Fly.io volume names only allow alphanumeric characters and underscores. The modules handle this automatically by replacing hyphens with underscores.

### Docker Compose Deployment

If you encounter issues with the Docker Compose deployment:
- Ensure flyctl is installed and authenticated
- Check that the HTML content path is correct
- Verify that the volumes are mounted correctly

### GitHub Actions

If CI/CD pipelines fail:
- Ensure all required secrets are configured in the GitHub repository
- Check that GitHub Environments are properly set up
- Verify that the workflows have the necessary permissions

## Security Considerations

- Never commit credentials to version control
- Use environment-specific API tokens when possible
- Consider using a secrets manager for production environments
- Use GitHub Environments for protected deployments

## Maintenance

- Keep your Terraform version up to date
- Regularly update the provider version in `provider.tf`
- Review and apply security updates 