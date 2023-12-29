# Installation by Helm

Use one by one scripts starting with service name. e.g:

```
bash elastic-install-operator.sh
bash elastic-install-helm.sh
```

To uninstall

```
bash elastic-uninstall-helm.sh
bash elastic-uninstall-operator.sh
```

# Install with ArgoCD

```
bash install-argocd-requirements.sh
```

Wait for all services to install

```
bash install.argocd-services.sh
```