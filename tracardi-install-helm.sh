NS="tracardi-com-082"
DOCKERHUB = "dckr_pat_-BIoW7LgPn1bSQNyr64HJantpzE"
VALUES = "local-com-values.yaml"

kubectl create ns $NS

kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS

helm upgrade --install tracardi tracardi -f tracardi/$VALUES -n $NS