kubectl create ns nats
helm upgrade --install nats nats/nats --values nats/local-values.yaml -n nats