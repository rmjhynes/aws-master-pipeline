#!/bin/bash

echo "This script will deploy a Terraform state bucket to your account and a Master Pipeline which will deploy worker pipelines that deploy code from their own designated repository."
echo
read -p "Press any key to continue." -n1 s
echo

echo "AWS Profiles:"
echo
aws configure list-profiles
echo
read -p "Choose a profile to use to deploy the Master Pipeline into the associated account: " profile
echo

export AWS_PROFILE=$profile

echo "Profile $profile selected!"
echo

echo "Deploying Terraform state bucket to AWS via CloudFormation..."
cd cloudformation
aws cloudformation create-stack --stack-name terraform-state-bucket --template-body file://bootstrap.yaml
echo

read -p "Please wait until this stack has been successfully deployed - check CloudFormation for updates. Once deployed, press any key to continue." -n 1 s
echo

echo "Deploying Master Pipeline via Terraform..."
echo
cd ../terraform/master-pipeline
terraform init -reconfigure -backend-config=backend.hcl
terraform apply -auto-approve

echo "The Master Pipeline has been successfully deployed!"
