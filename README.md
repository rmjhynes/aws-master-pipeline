# AWS Master Pipeline

A master pipeline that deploys worker pipelines to selected AWS accounts, with each worker pipeline pulling and deploying code from its own designated repository.  

---

## Components
- S3 bucket to store Terraform state (deployed by CloudFormation).
- S3 bucket for shared artifacts.
- AWS CodePipeline.
- AWS CodeBuild projects to generate a terraform plan file and then apply the configuration.
- IAM roles.
- CloudWatch Log Groups.

---

## Setup

### AWS Connector for GitHub
For each code repository that you want to pull code from, you will have to configure the AWS Connector for GitHub in your repo settings. This allows GitHub to trigger the pipelines when code is pushed to a repo.  

### Terraform State Bucket
The Terraform state bucket CloudFormation template is found in `/cloudformation` and should be created in the account in which you are deploying the `master-pipeline` to. This can be done manually in the console or using the AWS CLI.  

### Terraform State Configuration
To initialise the s3 backend for the master-pipeline, run:
`terraform init -reconfigure -backend-config=backend.hcl`

The s3 backend for the `pipelines-to-deploy` module is initialised in codebuild when it runs:
`terraform init -backend-config="key=<pipeline-name>.tfstate"`

If you want to destroy the resources related to any worker pipelines from your local - you have to run:
`terraform init -reconfigure -backend-config="key=<pipeline-name-that-deployed-the-resources>.tfstate"`
then
`terraform destroy`  

> [!IMPORTANT]
> For some reason, when the master pipeline is first deployed the source stage fails with a permissions error. Manually releasing the change will allow it to work.  

---

## To Be Fixed / Implemented

### Worker Pipelines Sourcing Build Specs
Due to the way the modules are configured and called via a `for_each`, the build specs for the worker pipelines cannot be sourced from this code repo because they already source code from their respective GitHub code repos. This needs to be fixed / changed as currently the worker pipeline codebuild projects cannot run without their build specs.
