https://min.io/docs/minio/kubernetes/upstream/operations/install-deploy-manage/deploy-minio-tenant.html#deploy-minio-distributed

# RUN
kubectl apply -f tenant-base.yaml

To Access forward:

minio-hl port 9000 no https
minio-console 9443 HTTPS
