NS="starrrocks"

kubectl create ns $NS
helm upgrade --install starrocks starrocks-community/kube-starrocks -f starrocks/local-values.yaml -n $NS