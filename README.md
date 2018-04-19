# Enumerest

A small server that counts requests on port 9999.

Endpoints:
* POST `/request/:id` - counts a request under the given `:id`
* POST `/requests/reset` - resets the counter
* GET `/summary` - shows all ids and their respective counts in JSON form


## Usage

** note** The server created by Terraform is meant for building purposes only and thus is not hardened or very secure. You should remove it after creating the release package.

Requirements:

* Digital Ocean account
* Terraform
* a `terraform/.env` file (see `terraform/.env.sample`)

Steps:

1. `source .env` - load your tfvars
2. `terraform init` - setup Terraform
3. `terraform apply` - will create a build machine on Digital Ocean from the Terraform file, copy the `master` git branch, and build a release. The release package will be returned to you as `./enumerest.tar.gz`.
4. It is now safe to `terraform destroy`, since the release package is saved locally.

The `enumerest.tar.gz` file can then be used on any Ubuntu 16.04x64 server by unpacking and executing `bin/enumerest foreground`


