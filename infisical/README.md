helm repo add infisical-helm-charts 'https://dl.cloudsmith.io/public/infisical/helm-charts/helm/charts/'
helm repo update

kubectl create ns infisical
kubectl apply -f secrets.yaml -n infisical
helm upgrade --install infisical infisical-helm-charts/infisical-standalone --values values.yaml -n infisical