kubectl create namespace redis
helm upgrade --install redis bitnami/redis --values local-values.yaml --namespace redis --create-namespace