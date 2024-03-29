kubectl create ns mariadb
kubectl create configmap mariadb-config --from-file=mariadb.cnf -n mariadb
kubectl create secret generic mariadb-root-password --from-literal=password=LvDMY7D2C78lC0hnBDPiZRcplxylVMU6 -n mariadb
// kubectl create secret generic mariadb-user-creds --from-literal=username=user --from-literal=password=pass -n mariadb
kubectl apply -f deployment.yaml -n mariadb
kubectl expose deployment mariadb-deployment --type=NodePort --name=mariadb-service --port=3306 -n mariadb
kubectl expose deployment mariadb-deployment --type=LoadBalancer --name=mariadb-service-lb --port=3306 -n mariadb