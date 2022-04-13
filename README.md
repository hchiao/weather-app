# weather-app
This response to the Woolie X tech challenge
https://hub.docker.com/r/dfranciswoolies/ciarecruitment-bestapiever

# Prerequisite

This documentation would require for the following to be actioned on 
* Subscribed to GCP account
* Project created
* Reserved an External IP address
* Registered a domain from Cloud DNS
* Create a secret in GCP Secret Manager
* Binaries installed (e.g. kubectl, helm, terraform, make, gcloud)

# Deployment of weather gke cluster

Deploy cluster resources:

1. `make gke-init`
1. `make gke-plan`
1. `make gke-apply`

Deploy resources in the cluster:

* `make install-on-gke`

# Deployment of weather application

The following command will deploy weather application on to the cluster:

* `make deploy`

# Clean up

## Clean up weather application

* `make destroy`

## Clean up weather cluster

Clean up resources in the cluster:

* `make uninstall-on-gke`

Clean up the cluster:

* `make gke-destroy`

# Help

* `make help`

# TODO

* CI/CD
* Network
* RBAC
* WAF
* CDN
* terraform apply the plan file
* terraform state file store remotely with lock
* parameterise terraform
* Testing
