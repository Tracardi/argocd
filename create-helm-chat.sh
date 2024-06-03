helm package tracardi
mv tracardi-0.9.0.tgz tracardi-helm-repo
helm repo index tracardi-helm-repo --url https://www.tracardi.com/helm
