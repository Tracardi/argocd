# Install with operator
https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/doc/deploy_starrocks_with_operator_howto.md
https://github.com/StarRocks/starrocks-kubernetes-operator/tree/main/examples/starrocks


## Add operator
kubectl apply -f https://raw.githubusercontent.com/StarRocks/starrocks-kubernetes-operator/main/deploy/starrocks.com_starrocksclusters.yaml
kubectl apply -f https://raw.githubusercontent.com/StarRocks/starrocks-kubernetes-operator/main/deploy/operator.yaml

## Install
kubectl apply -f starrocks/deployment.yaml -n starrocks

## Uninstall
kubectl delete -f https://raw.githubusercontent.com/StarRocks/starrocks-kubernetes-operator/main/deploy/operator.yaml
kubectl delete -f https://raw.githubusercontent.com/StarRocks/starrocks-kubernetes-operator/main/deploy/starrocks.com_starrocksclusters.yaml

# Install with helm
Details: https://docs.starrocks.io/docs/deployment/helm/


# Install

```
helm repo add starrocks-community https://starrocks.github.io/starrocks-kubernetes-operator
helm repo add starrocks https://starrocks.github.io/starrocks-kubernetes-operator
helm repo update



kubectl create ns starrocks
helm upgrade -f starrocks/local-values.yaml --install starrocks starrocks-community/kube-starrocks -n starrocks
helm upgrade -f starrocks/local-values.yaml --install starrocks starrocks/kube-starrocks -n starrocks
```

# Uninstall

```
helm uninstall starrocks -n starrocks
```

More information:
https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/doc/deploy_starrocks_with_helm_howto.md
https://github.com/StarRocks/starrocks-kubernetes-operator/blob/main/doc/local_installation_how_to.md