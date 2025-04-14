kubectl create namespace redis
helm upgrade --install redis bitnami/redis --values redis/min-values.yaml --namespace redis --create-namespace