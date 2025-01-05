NS="percona"

kubectl delete pxc percona-db-pxc-db -n $NS

helm delete percona-op --namespace $NS
helm delete percona-db --namespace $NS

#kubectl delete namespace $NS
