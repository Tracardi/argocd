NS="tracardi-com-082"
VALUES="local-com-values.yaml"
DOCKERHUB="dckr_pat_-BIoW7LgPn1bSQNyr64HJantpzE"

kubectl create ns $NS

kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS

helm upgrade --install tracardi tracardi -f tracardi/$VALUES -n $NS