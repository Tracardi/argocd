kubectl create ns elastic
helm upgrade --install elastic elastic --values elastic/min-values.yaml -n elastic
