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
The Terraform state bucket CloudFormation template is found in `/cloudformation` and should be created in the account in which you are deploying the `master-pipeline` to. This can be done manually in the console or using the script `deploy.sh`.  

### Terraform State Configuration
To initialise the s3 backend for the `master-pipeline`, run:
`terraform init -reconfigure -backend-config=backend.hcl` in `/master-pipeline`

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

### Worker Pipeline Backend Configurations
At the moment there is a `backend.hcl` file for just the  `master-pipeline`. I now need to pass in the whole backend config for each pipeline that is deployed as the repos that they are pulling code from don't have an s3 backend block in the terraforn block in `providers.tf`, hence it uses a local state file every time and then cannot read the resources that its already deployed. Refer to the differences in `providers.tf` in `aws-sample-config` repo and `aws-master-pipeline` repo.
