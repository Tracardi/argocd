NS="starrocks"

helm delete starrocks -n $NS
kubectl delete ns $NS
