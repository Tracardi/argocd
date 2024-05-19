NS="tracardi-com-090"
VALUES="090-eq-com-values.yaml"

helm upgrade --install tracardi tracardi -f tracardi/$VALUES -n $NS
