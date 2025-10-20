# Run

kubectl create ns $NS

kubectl create secret docker-registry airembr-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n airembr

