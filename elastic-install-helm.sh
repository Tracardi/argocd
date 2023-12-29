kubectl create ns elastic
helm upgrade --install elastic elastic --values elastic/local-values.yaml -n elastic
