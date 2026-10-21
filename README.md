# GCP hobby infrastructure

This public repository is the Terraform source of truth for all GCP resources.
Each independently managed project lives under `projects/<name>` and keeps its
own local Terraform state.

## Projects

- [`rpi-yolo-hue-api`](projects/rpi-yolo-hue-api/README.md)
  - private Cloud Storage bucket in `EUROPE-NORTH1`

## Using Terraform

Install an ARM64-compatible Terraform release on Apple silicon, then
authenticate Terraform with Google Cloud Application Default Credentials:

```sh
gcloud auth application-default login
```

Each directory under `projects/` is an independent Terraform root. To manage
the `rpi-yolo-hue-api` resources:

```sh
cd projects/rpi-yolo-hue-api
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars and replace both placeholder values.

terraform init
terraform fmt -check
terraform validate
terraform plan -out=terraform.tfplan
terraform apply terraform.tfplan
```

Run Terraform commands from the relevant project directory and review every
plan before applying it. The project README contains output, verification,
update, and teardown instructions.

## Note

Real project IDs, globally unique resource names, state files, plans, and
credentials are local-only and ignored by Git. Commit `.terraform.lock.hcl`
after provider initialization so provider selections remain reproducible.

If resources are shared by multiple projects in the future, place their
independent Terraform root under `shared/`. Do not couple shared resources to a
project's state.
