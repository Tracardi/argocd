kubectl delete pxc percona-db-pxc-db -n percona-2

helm delete percona-db --namespace percona-2
helm delete percona-op --namespace percona-2

#kubectl delete namespace percona-2
