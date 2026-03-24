# Run

kubectl create ns airembr

kubectl create secret docker-registry airembr-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n airembr

# Install with helm

helm upgrade --wait --timeout=1200s \
--install airembr airembr \
--values airembr/values_install.yaml \
--namespace airembr  --create-namespace

