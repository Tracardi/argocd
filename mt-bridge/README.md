```
helm template mt-bridge --values tracardi/090-mt-com-values.yaml
```

```
helm upgrade --wait --timeout=1200s --install --values mt-local-values.yaml mt-bridge --namespace tracardi-090 --create-namespace
```

# Delete

```
helm delete mt-bridge --namespace tracardi-090
```
