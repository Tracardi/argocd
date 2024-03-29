NS="tracardi-com-090"
#VALUES="090-local-com-values.yaml"
#VALUES="090-eq-com-values.yaml"
VALUES="090-uf-com-values.yaml"
DOCKERHUB="dckr_pat_JHTY5gyyruN_w9G3C2MbW7MeBVI"

kubectl create ns $NS

kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS

helm upgrade --install tracardi tracardi -f tracardi/$VALUES -n $NS


kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=dckr_pat_JHTY5gyyruN_w9G3C2MbW7MeBVI \
    -n tracardi