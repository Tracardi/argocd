# Install with helm

helm upgrade --wait --timeout=1200s \
--install tracardi tracardi \
--values tracardi/instance-values.yaml \
--namespace tracardi-com-082  --create-namespace
