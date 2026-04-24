helm upgrade --install rustfs rustfs/rustfs  \
 -n rustfs  \
 --set mode.standalone.enabled=true \
 --set mode.distributed.enabled=false \
 --set replicaCount=1 \
 --set ingress.enabled=true \
 --set ingress.hosts[0].host=rustfs.192.168.1.119.nip.io
