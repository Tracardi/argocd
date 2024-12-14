kubectl create ns valkey-cluster

helm upgrade --install valkey oci://registry-1.docker.io/bitnamicharts/valkey-cluster -n valkey-cluster
helm uninstall valkey -n valkey-cluster

export VALKEY_PASSWORD=$(kubectl get secret --namespace "valkey-cluster" valkey-valkey-cluster -o jsonpath="{.data.valkey-password}" | base64 -d)


# Installation with exposed network

helm upgrade valkey --install \
--set "password=${VALKEY_PASSWORD},cluster.externalAccess.enabled=true,cluster.externalAccess.service.port=11000,global.defaultStorageClass=local-path" \
 oci://registry-1.docker.io/bitnamicharts/valkey-cluster -n valkey-cluster

# Get password or set it manually
export VALKEY_PASSWORD=$(kubectl get secret --namespace "valkey-cluster" valkey-valkey-cluster -o jsonpath="{.data.valkey-password}" | base64 -d)

# Then run upgrade - to start loadbalancers and pods (SET ClusterIP for Load balancers)

helm upgrade --namespace valkey-cluster valkey --set "password=RY3aSXgA8k,cluster.externalAccess.enabled=true,cluster.externalAccess.service.type=LoadBalancer,cluster.externalAccess.service.loadBalancerIP[0]=10.43.88.218,cluster.externalAccess.service.loadBalancerIP[1]=10.43.117.65,cluster.externalAccess.service.loadBalancerIP[2]=10.43.253.82,cluster.externalAccess.service.loadBalancerIP[3]=10.43.119.189,cluster.externalAccess.service.loadBalancerIP[4]=10.43.61.69,cluster.externalAccess.service.loadBalancerIP[5]=10.43.3.9" oci://registry-1.docker.io/bitnamicharts/valkey-cluster

