# https://github.com/mysql/mysql-ndb-operator/

helm repo add ndb-operator-repo https://mysql.github.io/mysql-ndb-operator/
helm repo update
helm install ndb-operator ndb-operator-repo/ndb-operator --namespace=mysql-ndb-operator --create-namespace
kubectl create ns mysql-ndb

# https://github.com/mysql/mysql-ndb-operator/blob/main/docs/getting-started.md
# https://github.com/mysql/mysql-ndb-operator/blob/main/docs/NdbCluster-CRD.md
kubectl apply -f mysql-cluster.yaml -n mysql-ndb