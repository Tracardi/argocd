# Make sure that the default storage class is not longhorn
 We had issues installing Starrocks on longhorn


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

Nie udało mi sie zainstalowac z operatora

