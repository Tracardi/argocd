kubectl create namespace monitoring
kubectl apply -f alloy-config.yaml -n alloy


helm install alloy grafana/alloy \
  --namespace monitoring \
  --set controller.type=daemonset \
  --set alloy.configMap.create=false \
  --set alloy.configMap.name=alloy-config \
  --set alloy.configMap.key=config.alloy

helm uninstall alloy -n monitoring