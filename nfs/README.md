kubectl create namespace nfs
kubectl apply -f nfs/nfs-pv.yaml -n nfs
kubectl apply -f nfs/nfs-pvc.yaml -n nfs
kubectl apply -f nfs/nfs-server.yaml -n nfs
kubectl apply -f nfs/nfs-service.yaml -n nfs
