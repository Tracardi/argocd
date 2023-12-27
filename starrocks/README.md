Details: https://docs.starrocks.io/docs/deployment/helm/

```
helm repo add starrocks-community https://starrocks.github.io/starrocks-kubernetes-operator
helm repo update
kubectl create ns starrrocks
helm upgrade -f starrocks/values.yaml --install starrocks starrocks-community/kube-starrocks -n starrrocks
```