mkdir -p tracardi-helm-repo/1.0.2
helm package tracardi
mv tracardi-1.0.2.tgz tracardi-helm-repo/1.0.2
helm repo index tracardi-helm-repo/1.0.2 --url https://www.tracardi.com/helm/1.0.2/
#scp -P 222 -r tracardi-helm-repo/1.0.2 kuptoo@s113.linuxpl.com:/domains/tracardi.com/public_html/helm/1.0.2
