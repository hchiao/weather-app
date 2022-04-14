help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

login-gcp: ## Login in to GCP (For User)
	gcloud auth application-default login

login-gke: ## Login to cluster (get kubeconfig)
	gcloud container clusters get-credentials weather-cluster --region australia-southeast1 --project gke-hello-world-253604

deploy: ## Deploy weather app
	helm upgrade --install  --values ./weather-helm/values.yaml weather ./weather-helm

destroy: ## Destroy weather app
	helm uninstall weather ./weather-helm

gke-init: ## Terraform init
	terraform -chdir=./terraform-gke init

gke-plan: ## Terraform plan
	terraform -chdir=./terraform-gke plan

gke-apply: ## Terraform apply
	terraform -chdir=./terraform-gke apply

gke-destroy: ## Terraform destroy
	terraform -chdir=./terraform-gke destroy

# https://secrets-store-csi-driver.sigs.k8s.io/getting-started/installation.html
# https://github.com/GoogleCloudPlatform/secrets-store-csi-driver-provider-gcp
# https://github.com/kubernetes-sigs/secrets-store-csi-driver/issues/600
install-gke-add-ons: ## Install cluster add-ons
	cd ./gke-add-ons; \
	helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts; \
	helm install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --namespace kube-system --set syncSecret.enabled=true; \
	kubectl apply -f ./secrets-store-csi-driver-provider-gcp/deploy/provider-gcp-plugin.yaml; \
	export PROJECT_ID=gke-hello-world-253604; \
	export CLOUDSDK_CORE_PROJECT=$$PROJECT_ID; \
	gcloud iam service-accounts create gke-workload; \
	gcloud iam service-accounts add-iam-policy-binding --role roles/iam.workloadIdentityUser --member "serviceAccount:$$PROJECT_ID.svc.id.goog[default/mypodserviceaccount]" gke-workload@$$PROJECT_ID.iam.gserviceaccount.com; \
	gcloud secrets add-iam-policy-binding testsecret --member=serviceAccount:gke-workload@$$PROJECT_ID.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor --project $$PROJECT_ID

uninstall-gke-add-ons: ## Uninstall cluster add-ons
	cd ./gke-add-ons; \
	export PROJECT_ID=gke-hello-world-253604; \
	export CLOUDSDK_CORE_PROJECT=$$PROJECT_ID; \
	gcloud iam service-accounts delete gke-workload@gke-hello-world-253604.iam.gserviceaccount.com; \
	kubectl delete -f ./secrets-store-csi-driver-provider-gcp/deploy/provider-gcp-plugin.yaml; \
	helm uninstall csi-secrets-store --namespace kube-system

