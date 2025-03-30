kubectl create ns elastic
helm upgrade --install elastic elastic --values local-values.yaml -n elastic
