help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

deploy: ## Deploy weather app
	helm upgrade --install  --values ./weather-helm/values.yaml weather ./weather-helm

destroy: ## Destroy weather app
	helm uninstall weather ./weather-helm

login: ## Login in to GCP (For User)
	gcloud auth application-default login

terraform-gke-init: ## Terraform init
	terraform -chdir=./terraform-gke init

terraform-gke-plan: ## Terraform plan
	terraform -chdir=./terraform-gke plan

terraform-gke-apply: ## Terraform apply
	terraform -chdir=./terraform-gke apply

terraform-gke-destroy: ## Terraform destroy
	terraform -chdir=./terraform-gke destroy
