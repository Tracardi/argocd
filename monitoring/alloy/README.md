kubectl create namespace alloy
kubectl apply -f alloy-config.yaml -n alloy


helm install alloy grafana/alloy \
  --namespace alloy \
  --set controller.type=daemonset \
  --set alloy.configMap.create=false \
  --set alloy.configMap.name=alloy-config \
  --set alloy.configMap.key=config.alloy

