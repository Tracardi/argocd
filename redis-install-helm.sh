kubectl create namespace redis
helm install redis bitnami/redis --values redis/local-values.yaml --namespace redis --create-namespace