# RUN THIS FIRST

kubectl apply -f namespace.yaml
kubectl apply -f kafka-jaas.yaml
kubectl apply -f kafka-sasl.yaml
kubectl apply -f traefik-config.yaml
kubectl apply -f kafka-traefik.yaml
kubectl apply -f kafka-stateful-bootstrap.yaml

# Then rollout

kubectl rollout status deployment/traefik -n kube-system
kubectl rollout status statefulset/kafka -n kafka

# THen verify
kubectl get svc traefik -n kube-system

# Then register
kubectl exec -n kafka kafka-0 -- \
  /opt/kafka/bin/kafka-configs.sh \
  --bootstrap-server kafka-0.kafka-headless.kafka.svc.cluster.local:9094 \
  --alter \
  --add-config 'SCRAM-SHA-512=[password=jaas-secret]' \
  --entity-type users \
  --entity-name admin

## Output
Completed updating config for user admin.