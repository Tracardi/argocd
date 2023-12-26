kubectl create ns starrrocks
helm upgrade -f starrocks/values.yaml --install starrocks starrocks-community/kube-starrocks -n starrrocks