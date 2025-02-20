args := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

SHELL=/bin/zsh
PROJECT=lab-crossplane

help: ## Print help for each target
	$(info =============================)
	$(info Available commands:)
	$(info )
	@grep '^[[:alnum:]_-]*:.* ##' $(MAKEFILE_LIST) \
		| sort | awk 'BEGIN {FS=":.* ## "}; {printf "%-25s %s\n", $$1, $$2};'
	$(info =============================)

kind-up: ## Create Kind cluster
	@echo "Creating kind cluster $(PROJECT)"
	kind create cluster --name $(PROJECT) --config kind/kind-config.yaml --wait 2m

kind-down: ## Destroy kind cluster
	kind delete cluster --name $(PROJECT)

argocd-install: ## Install ArgoCD into kind cluster
	@echo "Setting up ArgoCD"
	kubectl create namespace argocd 
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@sleep 10
	kubectl patch svc argocd-server -n argocd -p \
	  '{"spec": {"type": "NodePort", "ports": [{"name": "http", "nodePort": 30080, "port": 80, "protocol": "TCP", "targetPort": 8080}, {"name": "https", "nodePort":30443, "port": 443, "protocol": "TCP", "targetPort": 8083}]}}'
	@sleep 20
	@echo "ArgoCD Admin Secret: " && kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

.SILENT: argocd-install 
lab-kind-start: kind-up argocd-install ## Start all lab bring cluster and ArgoCD up

lab-kind-stop: kind-down ## Shutdown lab
