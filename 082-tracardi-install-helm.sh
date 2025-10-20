# Access to docker hub.

NS="tracardi"
DOCKER_HUB_TOKEN=""

kubectl create ns $NS
kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKER_HUB_TOKEN \
    -n $NS


# Install
VALUES="082-local-com-values.yaml"
helm upgrade --install tracardi tracardi -f values/$VALUES -n $NS