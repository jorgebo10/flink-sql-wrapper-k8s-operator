SHELL=/bin/bash
export CLUSTER_NAME=mccluster

setup: delete-kind-cluster create-kind-cluster install-flink-operator deploy-job

delete-kind-cluster:
	kind delete cluster --name ${CLUSTER_NAME}

create-kind-cluster: delete-kind-cluster
	kind create cluster --name ${CLUSTER_NAME}

display-kind-cluster:
	kubectl cluster-info --context kind-${CLUSTER_NAME}

install-flink-operator:
	kubectl create -f https://github.com/jetstack/cert-manager/releases/download/v1.8.2/cert-manager.yaml
	helm repo remove flink-kubernetes-operator
	helm repo add flink-kubernetes-operator https://archive.apache.org/dist/flink/flink-kubernetes-operator-1.7.0/
	helm install flink-kubernetes-operator flink-kubernetes-operator/flink-kubernetes-operator --set webhook.create=false

build-jar:
	mvn clean package

build-docker-image: build-jar
	DOCKER_BUILDKIT=1 docker build . -t flink-sql-runner:latest

load-image-kind-cluster: build-docker-image
	kind load docker-image flink-sql-runner:latest --name ${CLUSTER_NAME}

deploy-job: load-image-kind-cluster
	kubectl apply -f job.yaml

log-job:
	kubectl logs -f deploy/sql-example
forward-port:
	kubectl port-forward svc/sql-example-rest 8081