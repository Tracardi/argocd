NS="starrocks"

kubectl create ns $NS
helm upgrade --install starrocks starrocks-community/kube-starrocks -f local-values.yaml -n $NS