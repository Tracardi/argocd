helm package ../../tracardi
helm repo index . --url https://www.tracardi.com/helm/1.1.x/
#scp -P 222 -r tracardi-helm-repo/1.0.2 kuptoo@s113.linuxpl.com:/domains/tracardi.com/public_html/helm/1.0.2
