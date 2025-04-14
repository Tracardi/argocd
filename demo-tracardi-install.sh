NS="tracardi-11x"
VALUES="demo-values.yaml"
kubectl create ns $NS
helm upgrade --install tracardi tracardi -f values/$VALUES -n $NS