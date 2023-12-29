kubectl create ns starrrocks
helm upgrade --install starrocks starrocks-community/kube-starrocks -f starrocks/local-values.yaml -n starrrocks