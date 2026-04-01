kubectl create namespace lldap

kubectl -n lldap create secret generic lldap-secret \
  --from-literal=jwt-secret=supersecretjwt \
  --from-literal=admin-password=adminpassword

