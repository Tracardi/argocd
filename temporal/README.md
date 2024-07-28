helm upgrade \
    --install temporal temporal \
    --namespace temporal \
    --repo https://go.temporal.io/helm-charts \
    --set server.replicaCount=1 \
    --set cassandra.config.cluster_size=1 \
    --set elasticsearch.replicas=1 \
    --set prometheus.enabled=false \
    --set grafana.enabled=false \
    --values values.yaml \
    --timeout 15m

kubectl expose deployment temporal-frontend --name=temporal-fe-lb --type=LoadBalancer --port=7233 --target-port=7233 --namespace temporal
kubectl expose deployment temporal-web --name=temporal-web-lb --type=LoadBalancer --port=8181 --target-port=8080 --namespace temporal


helm delete temporal --namespace temporal

 /opt/temporal/temporal operator namespace create --namespace default --address 192.168.1.119:7233