# Install with helm

helm upgrade --wait --timeout=1200s \
--install airembr airembr \
--values airembr/local-core-values.yaml \
--namespace airembr  --create-namespace
