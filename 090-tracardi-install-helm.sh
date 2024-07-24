NS="tracardi-com-090"
VALUES="090-local-com-values.yaml"
DOCKERHUB=""

kubectl create ns $NS

kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS

helm upgrade --install tracardi tracardi -f values/$VALUES -n $NS
