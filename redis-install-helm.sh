kubectl create namespace redis
helm upgrade --install redis bitnami/redis --values redis/local-values.yaml --namespace redis --create-namespace