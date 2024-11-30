For some reason, when the master pipeline is first deployed the source stage fails with a permissions error. Manually releasing the change will allow it to work.

To initialise the s3 backend for the master-pipeline, run:
`terraform init -reconfigure -backend-config=backend.hcl`

The s3 backend for the `pipelines-to-deploy` module is initialised in codebuild when it runs:
`terraform init -backend-config="key=<pipeline-name>/terraform.tfstate"`

If you want to destroy the resources related to any worker pipelines from your local - you have to run:
`terraform init -reconfigure -backend-config="key=<pipeline-name-that-deployed-the-resources>.tfstate"`
then
`terraform destroy`
