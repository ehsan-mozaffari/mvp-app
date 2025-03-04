#!/bin/bash

# Script to simplify Terraform deployment to different environments

# Exit on any error
set -e

# Default values
ENVIRONMENT="dev"
ACTION="plan"
USE_ENV_VARS=false

# Process command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -e|--environment)
      ENVIRONMENT="$2"
      shift 2
      ;;
    -a|--action)
      ACTION="$2"
      shift 2
      ;;
    --env-vars)
      USE_ENV_VARS=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [environment] [action] [options]"
      echo "Examples:"
      echo "  $0 dev plan"
      echo "  $0 staging apply"
      echo "  $0 prod destroy"
      echo "  $0 docker-compose-dev apply"
      echo ""
      echo "Options:"
      echo "  --env-vars             Use environment variables instead of credentials.tfvars"
      echo "  -h, --help             Show this help message"
      exit 0
      ;;
    *)
      # Positional arguments
      if [[ -z "$ENVIRONMENT" || "$ENVIRONMENT" == "dev" ]]; then
        ENVIRONMENT="$1"
      elif [[ -z "$ACTION" || "$ACTION" == "plan" ]]; then
        ACTION="$1"
      else
        echo "Unknown option: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

# Validate environment
if [[ "$ENVIRONMENT" != "dev" && "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "prod" && "$ENVIRONMENT" != "docker-compose-dev" ]]; then
  echo "Error: Environment must be one of: dev, staging, prod, docker-compose-dev"
  exit 1
fi

# Validate action
if [[ "$ACTION" != "plan" && "$ACTION" != "apply" && "$ACTION" != "destroy" ]]; then
  echo "Error: Action must be one of: plan, apply, destroy"
  exit 1
fi

# Check if using environment variables or credentials file
if [[ "$USE_ENV_VARS" == false ]]; then
  # Check if credentials.tfvars exists
  CREDS_FILE="environments/$ENVIRONMENT/credentials.tfvars"
  if [[ ! -f "$CREDS_FILE" ]]; then
    if [[ -f "$CREDS_FILE.example" ]]; then
      echo "Warning: $CREDS_FILE not found."
      echo "Please copy $CREDS_FILE.example to $CREDS_FILE and update with your credentials"
      
      # Check if FLY_API_TOKEN environment variable is set
      if [[ -n "$FLY_API_TOKEN" ]]; then
        echo "FLY_API_TOKEN environment variable detected. Using environment variables instead."
        USE_ENV_VARS=true
      else
        exit 1
      fi
    else
      echo "Error: Neither $CREDS_FILE nor $CREDS_FILE.example found"
      exit 1
    fi
  fi
else
  # Verify that required environment variables are set
  if [[ -z "$FLY_API_TOKEN" ]]; then
    echo "Error: FLY_API_TOKEN environment variable is not set"
    echo "Please set it using: export FLY_API_TOKEN=your_token"
    exit 1
  fi
fi

# Check for Docker Compose environment prerequisites
if [[ "$ENVIRONMENT" == "docker-compose-dev" ]]; then
  # Check if flyctl is installed
  if ! command -v flyctl &> /dev/null; then
    echo "Error: flyctl command not found"
    echo "Please install flyctl: https://fly.io/docs/hands-on/install-flyctl/"
    exit 1
  fi
  
  # Check if flyctl is authenticated
  if ! flyctl auth whoami &> /dev/null; then
    echo "Error: Not authenticated with Fly.io"
    echo "Please run 'flyctl auth login' to authenticate"
    exit 1
  fi
fi

# Navigate to the environment directory
cd "environments/$ENVIRONMENT"

# Initialize if .terraform directory doesn't exist
if [[ ! -d .terraform ]]; then
  echo "Initializing Terraform for $ENVIRONMENT environment..."
  terraform init
fi

# Set var file argument based on whether we're using env vars or credentials file
if [[ "$USE_ENV_VARS" == true ]]; then
  VAR_ARGS="-var=fly_api_token=$FLY_API_TOKEN"
  echo "Using environment variables for authentication"
else
  VAR_ARGS="-var-file=credentials.tfvars"
  echo "Using credentials.tfvars file for authentication"
fi

# Execute the requested action
case $ACTION in
  plan)
    echo "Planning changes for $ENVIRONMENT environment..."
    terraform plan $VAR_ARGS
    ;;
  apply)
    echo "Applying changes to $ENVIRONMENT environment..."
    terraform apply $VAR_ARGS
    ;;
  destroy)
    echo "CAUTION: Destroying resources in $ENVIRONMENT environment..."
    echo "Are you sure? Type 'yes' to confirm:"
    read confirmation
    if [[ "$confirmation" == "yes" ]]; then
      terraform destroy $VAR_ARGS
    else
      echo "Destruction cancelled."
      exit 0
    fi
    ;;
esac

echo "Terraform $ACTION completed for $ENVIRONMENT environment" 