# Terraform for Fly.io Project

This project contains an enterprise-ready Terraform configuration for managing Fly.io infrastructure. It provides a modular approach to infrastructure as code for deploying applications on Fly.io.

## Project Structure

```
├── terraform/                # Terraform configuration root
│   ├── modules/              # Reusable Terraform modules
│   ├── environments/         # Environment-specific configurations
│   ├── README.md             # Terraform-specific documentation
│   └── ...                   # Other Terraform files
├── html/                     # HTML content for the web server
│   └── index.html            # Sample HTML file
├── compose.yml               # Docker Compose configuration
└── .github/                  # GitHub configuration
    └── workflows/            # GitHub Actions workflows
```

## Getting Started

See the [terraform/README.md](terraform/README.md) file for detailed instructions on setting up and using the Terraform configuration.

### Quick Start

1. Install Terraform (v1.0.0 or newer)
2. Get a Fly.io API token from your Fly.io dashboard
3. Navigate to the environment directory you want to deploy
   ```
   cd terraform/environments/dev
   ```
4. Copy the credentials example file and add your API token
   ```
   cp credentials.tfvars.example credentials.tfvars
   # Edit credentials.tfvars to add your API token
   ```
5. Initialize and apply Terraform
   ```
   terraform init
   terraform apply -var-file=credentials.tfvars
   ```

### Docker Compose Deployment

To deploy your Docker Compose configuration to Fly.io:

1. Install flyctl and authenticate with Fly.io
2. Navigate to the Docker Compose environment directory:
   ```
   cd terraform/environments/docker-compose-dev
   ```
3. Copy the credentials example file and add your API token:
   ```
   cp credentials.tfvars.example credentials.tfvars
   # Edit credentials.tfvars to add your API token
   ```
4. Deploy using Terraform:
   ```
   terraform init
   terraform apply -var-file=credentials.tfvars
   ```

### CI/CD with GitHub Actions

This project includes GitHub Actions workflows for automated testing and deployment:

1. **PR Validation**: Automatically runs on pull requests to validate your Terraform changes
2. **Environment Deployment**: Automatically deploys to the appropriate environment based on the branch:
   - `develop` branch → `dev` environment
   - `staging` branch → `staging` environment
   - `main` branch → `prod` environment

To use GitHub Actions:

1. Push your repository to GitHub
2. Configure the following repository secrets:
   - `FLY_API_TOKEN`: Your Fly.io API token
3. Set up GitHub Environments for deployment protection
4. Make a pull request or push to one of the deployment branches

For more details, see the [GitHub Actions workflows README](.github/workflows/README.md).

### Using Environment Variables (Alternative)

Instead of using tfvars files, you can use environment variables:

1. Copy the .envrc.example file to .envrc (if using direnv)
   ```
   cp terraform/.envrc.example terraform/.envrc
   ```
2. Edit the .envrc file to add your Fly.io API token
3. Allow direnv to load the environment variables
   ```
   cd terraform
   direnv allow
   ```
4. Use the deployment script
   ```
   ./deploy.sh --environment dev --action plan
   ```

## Features

- **Modular Design**: Separate modules for apps, machines, and volumes
- **Environment Separation**: Distinct configurations for dev, staging, and production
- **Secure Authentication**: API token stored in a separate, gitignored file
- **Scalable Infrastructure**: Configure multiple regions with ease
- **Deployment Script**: Simplified command-line interface for deployment
- **Docker Compose Support**: Deploy your Docker Compose applications to Fly.io
- **CI/CD Integration**: GitHub Actions for automated testing and deployment

## Requirements

- Terraform v1.0.0 or newer
- Fly.io account with API access
- Basic knowledge of Terraform and Fly.io
- (Optional) direnv for environment variable management
- (Optional) flyctl for Docker Compose deployments
- (Optional) GitHub account for CI/CD

## Security Considerations

- Never commit your credentials.tfvars or .envrc file to version control
- Rotate your Fly.io API tokens regularly
- Use least-privilege access for your API tokens
- Use GitHub Environments for protected deployments

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
