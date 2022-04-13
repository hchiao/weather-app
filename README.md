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

# Deployment of weather application

1. `make deploy`

## Clean up

1. `make destroy`

# Help

1. `make help`

# TODO

* CI/CD
* Network
* RBAC
* WAF
* CDN
* terraform apply the plan file
* terraform state file store remotely with lock
* Testing
