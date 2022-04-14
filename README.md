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

# Provision GKE weather cluster

Deploying gke cluster:

1. `make login-gcp`
1. `make gke-init`
1. `make gke-plan`
1. `make gke-apply`

Installing gke add-ons:

1. `make login-gke`
1. `make install-gke-add-ons`

# Deployment of weather application

The following command will deploy weather application on to the cluster:

1. `make login-gke`
1. `make deploy`

# Test access to weather app

From your mobile phone or any browser access the following url

```
https://somenametoremember.com/weatherforecast

or

https://somenametoremember.com/health
```

# Clean up

## Clean up weather application

1. `make login-gke`
1. `make destroy`

## Clean up weather cluster

Clean up resources in the cluster:

1. `make login-gke`
1. `make uninstall-gke-add-ons`

Clean up the cluster:

* `make gke-destroy`

# Help

* `make help`

# TODO

* Make secret config more dynamic
* CI/CD
* Network
* RBAC
* WAF
* CDN
* terraform apply the plan file
* terraform state file store remotely with lock
* parameterise terraform
* Testing
