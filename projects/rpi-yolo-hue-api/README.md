# rpi-yolo-hue-api infrastructure

This Terraform root manages one private, regional Cloud Storage bucket for the
`rpi-yolo-hue-api` project.

The bucket uses `STANDARD` storage in `EUROPE-NORTH1`, uniform bucket-level
access, enforced public-access prevention, and seven-day soft delete. Object
versioning and hierarchical namespace are disabled. Use slash-delimited object
names such as `images/test.jpg` for normal folder-style organization.

Terraform does not create a GCP project, service account, IAM binding, or bucket
objects. Grant service-account access separately when it is needed.

## Prerequisites

- Terraform 1.5 or newer, but earlier than Terraform 2.0
- An ARM64-compatible Terraform binary on Apple silicon
- Google Cloud CLI authenticated to an account that can create buckets in the
  existing project
- A globally unique Cloud Storage bucket name

Authenticate Terraform through Google Cloud Application Default Credentials:

```sh
gcloud auth application-default login
```

## Configure local values

Copy the example file and replace both placeholders. `terraform.tfvars` is
ignored by Git and must not be committed.

```sh
cp terraform.tfvars.example terraform.tfvars
```

```hcl
project_id  = "your-existing-gcp-project-id"
bucket_name = "your-globally-unique-bucket-name"
```

## Initialize and validate

```sh
terraform init
terraform fmt -check
terraform validate
```

`terraform init` downloads the Google provider and creates or updates
`.terraform.lock.hcl`. Commit the lock file, but not the `.terraform/`
directory.

## Plan and apply

Create a saved plan, review it, and apply exactly that plan:

```sh
terraform plan -out=terraform.tfplan
terraform show terraform.tfplan
terraform apply terraform.tfplan
```

The plan should contain one `google_storage_bucket` resource and no IAM or
service-account resources. Repeat the plan-and-apply workflow to make later
changes.

State is local and ignored by Git. Back up `terraform.tfstate` securely; without
it, Terraform cannot reliably track the bucket it created.

Sensitive outputs are hidden in normal output. Retrieve them explicitly when
needed:

```sh
terraform output -raw bucket_name
terraform output -raw bucket_url
```

To verify folder-style paths after access is configured, upload and list a test
object:

```sh
gcloud storage cp ./test.jpg "gs://BUCKET_NAME/images/test.jpg"
gcloud storage ls "gs://BUCKET_NAME/images/"
```

## Preview or remove infrastructure

Preview destruction before removing the bucket:

```sh
terraform plan -destroy
terraform destroy
```

The bucket uses `force_destroy = false`, so Terraform refuses to delete a
non-empty bucket. Remove objects intentionally before destroying it. Deleted
objects remain recoverable under the configured seven-day soft-delete policy.
