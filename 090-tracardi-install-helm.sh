NS="tracardi-com-090"
#VALUES="090-local-com-values.yaml"
#VALUES="090-uf-values.yaml"
VALUES="090-hl-com-values.yaml"
DOCKERHUB="dckr_pat_v_3C-NJQbY1nWBrsktNbtfeGOgA"

kubectl create ns $NS

kubectl create secret docker-registry tracardi-dockerhub \
    --docker-server=index.docker.io/v1/  \
    --docker-username=tracardi \
    --docker-password=$DOCKERHUB \
    -n $NS

helm upgrade --install tracardi tracardi -f tracardi/$VALUES -n $NS