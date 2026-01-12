kubectl create namespace monitoring

helm upgrade --install loki grafana/loki \
  --namespace monitoring \
  -f single-loki-values.yaml

  # More

  https://grafana.com/docs/loki/latest/setup/install/helm/install-monolithic/
  https://grafana.com/docs/loki/latest/setup/install/helm/install-scalable/


helm uninstall loki --namespace monitoring

# Adding to graphana

- Goto Connections -> Data Sources -> Add data source
- Add loki as http://loki:3100
- In HTTP headers add header: X-Scope-OrgID: k3s
