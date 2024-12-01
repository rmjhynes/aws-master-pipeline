# AWS Master Pipeline

## A master pipeline that deploys worker pipelines to selected AWS accounts, with each worker pipeline pulling and deploying code from its own designated repository.  

### Components
- S3 bucket to store Terraform state (deployed by CloudFormation).
- AWS CodePipeline.
- AWS CodeBuild projects to generate a terraform plan file and then apply the configuration.
- IAM roles.
- CloudWatch Log Groups.  

> [!IMPORTANT]
> For some reason, when the master pipeline is first deployed the source stage fails with a permissions error. Manually releasing the change will allow it to work.  

### Terraform State Configuration
To initialise the s3 backend for the master-pipeline, run:
`terraform init -reconfigure -backend-config=backend.hcl`

The s3 backend for the `pipelines-to-deploy` module is initialised in codebuild when it runs:
`terraform init -backend-config="key=<pipeline-name>.tfstate"`

If you want to destroy the resources related to any worker pipelines from your local - you have to run:
`terraform init -reconfigure -backend-config="key=<pipeline-name-that-deployed-the-resources>.tfstate"`
then
`terraform destroy`  

### AWS Connector for GitHub
For each code repository that you want to pull code from, you will have to configure the AWS Connector for GitHub in your repo settings. This allows GitHub to trigger the pipelines when code is pushed to a repo.
