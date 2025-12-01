NS="airembr-recall"
DOCKERHUB="dckr_pat_JHTY5gyyruN_w9G3C2MbW7MeBVI"

kubectl create ns $NS

kubectl create secret docker-registry dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS