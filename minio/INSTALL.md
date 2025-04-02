# Install operator

describe what operator does
kubectl kustomize github.com/minio/operator\?ref=v7.0.1 | kubectl apply -f -

# Install deployment

kubectl apply -f deployment.yaml -n minio 


# Install ingress
kubectl apply -f ingress.yaml -n minio 