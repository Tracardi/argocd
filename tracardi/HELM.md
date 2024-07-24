# Install with helm

helm upgrade --wait --timeout=1200s \
--install tracardi tracardi \
--values tracardi/local-core-values.yaml \
--namespace tracardi  --create-namespace
