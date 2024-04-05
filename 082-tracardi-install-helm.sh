NS="tracardi-com-082"
VALUES="082-local-com-values.yaml"
DOCKERHUB=""

kubectl create ns $NS

kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS

helm upgrade --install tracardi tracardi -f tracardi/$VALUES -n $NS