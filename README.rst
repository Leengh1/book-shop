Django Application — CI/CD & Deployment Pipeline

Overview
This project presents a complete CI/CD workflow for a Django application, covering the full process from packaging the code to building Docker images, managing versions, and deploying automatically to an AWS EC2 instance.

Pipeline Flow
The pipeline is triggered automatically on code pushes:
* dev branch → development deployment
* main branch → production deployment

1. Version Handling
* Extracts the application version from pyproject.toml
* Stores it as an artifact for later stages

2. Build Stage
* Installs dependencies using Poetry
* Builds the application into a .whl package
* Uploads build artifacts

3. Docker Stage
* Builds a Docker image using the packaged application
* Tags the image using the extracted version
* Pushes the image to AWS ECR

4. Image Selection
* Retrieves the latest development image from ECR

5. Promotion (Production Only)
* Converts development image into a production-ready version
* Removes .dev suffix from the tag

6. Deployment
Development Environment
* Runs container:
    * Container port: 4000
    * Host port: 8080

Production Environment
* Runs container:
    * Container port: 3000
    * Host port: 3000
* Nginx is configured to forward traffic from port 80

AWS Infrastructure
EC2
* Instance type: t3.small
* Storage: 30 GB EBS
Security Group Rules:
* 22 (SSH)
* 80 (HTTP)
* 8080 (development access)

IAM
CI/CD User
* IAM user used by GitHub Actions
* Attached policy:
    * AmazonEC2ContainerRegistryPowerUser

EC2 Role
* Role name: access-ecr
* Attached policy:
    * AmazonEC2ContainerRegistryPowerUser
Used to allow the instance to pull images from ECR.

ECR
* Private repository: django-app
* Immutable tags enabled
* Stores all versioned images

Server Setup (EC2)
The EC2 instance is prepared using a setup script : config.sh
What it installs:
* Nginx 
* Docker 
* AWS CLI

Nginx Configuration
Configured automatically during deployment:
* Listens on port 80
* Proxies traffic to: http://127.0.0.1:3000

GitHub Secrets
The following secrets are required:
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY
* AWS_REGION
* AWS_ECR_URL
* ACCOUNT_ID
* HOST
* HOST_NAME
* KEY

Key Features
* Fully automated CI/CD pipeline
* Version-based Docker image tagging
* Separate development and production workflows
* Image promotion strategy
* Automated deployment via SSH
* AWS ECR integration
* Nginx reverse proxy setup
