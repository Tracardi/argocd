Alright — let’s set up **Dex on k3s/Kubernetes step by step** in a clean, working way 👍

This will:

* run Dex
* connect it to your **LLDAP**
* expose it via NodePort (simple)

---

# 🚀 1. Create namespace

```bash
kubectl create namespace dex
```

---

# 🔐 2. Create config (Dex + LLDAP)

Save as `config.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dex-config
  namespace: dex
data:
  config.yaml: |
    issuer: http://<NODE-IP>:30556

    storage:
      type: memory

    web:
      http: 0.0.0.0:5556

    connectors:
      - type: ldap
        id: ldap
        name: LLDAP
        config:
          host: lldap.lldap.svc.cluster.local:3890
          insecureNoSSL: true

          bindDN: uid=admin,ou=people,dc=example,dc=local
          bindPW: admin12345

          userSearch:
            baseDN: ou=people,dc=example,dc=local
            filter: "(objectClass=inetOrgPerson)"
            username: uid
            idAttr: uid
            emailAttr: mail
            nameAttr: cn

          groupSearch:
            baseDN: ou=groups,dc=example,dc=local
            filter: "(objectClass=groupOfNames)"
            userAttr: DN
            groupAttr: member
            nameAttr: cn

    staticClients:
      - id: example-app
        redirectURIs:
          - "http://localhost:8000/callback"
        name: example-app
        secret: supersecret
```

👉 Replace:

```text
<NODE-IP>
```

with your node IP

---

# ⚙️ 3. Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dex
  namespace: dex
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dex
  template:
    metadata:
      labels:
        app: dex
    spec:
      containers:
        - name: dex
          image: ghcr.io/dexidp/dex:latest
          args:
            - dex
            - serve
            - /etc/dex/config.yaml
          ports:
            - containerPort: 5556
          volumeMounts:
            - name: config
              mountPath: /etc/dex
      volumes:
        - name: config
          configMap:
            name: dex-config
```

---

# 🌐 4. NodePort Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: dex
  namespace: dex
spec:
  type: NodePort
  selector:
    app: dex
  ports:
    - port: 5556
      targetPort: 5556
      nodePort: 30556
```

---

# ▶️ 5. Apply everything

```bash
kubectl apply -f dex-config.yaml
kubectl apply -f dex-deployment.yaml
kubectl apply -f dex-service.yaml
```

---

# 🧪 6. Verify

Check logs:

```bash
kubectl -n dex logs -f deployment/dex
```

---

# 🌐 7. Test Dex

Open:

```text
http://<NODE-IP>:30556/.well-known/openid-configuration
```

👉 You should see JSON → Dex is working ✅

---

# 🔐 8. Test login flow (manual)

Open:

```text
http://<NODE-IP>:30556/auth?client_id=example-app&redirect_uri=http://localhost:8000/callback&response_type=code&scope=openid
```

👉 You should see:

* Dex login screen
* LDAP (LLDAP) auth

---

# 🧠 Important notes

## 🔥 LLDAP connection

Make sure this works:

```text
lldap.lldap.svc.cluster.local:3890
```

👉 If not:

```bash
kubectl get svc -n lldap
```

---

## ⚠️ No TLS (dev only)

Currently:

```text
http://
```

👉 For real use → add Ingress + HTTPS

---

## ⚠️ storage: memory

```yaml
storage:
  type: memory
```

👉 OK for dev, not prod

---

# 🚀 What you can do next

Now you have:

```text
User → Dex → LLDAP → identity
```

👉 Next steps I can help with:

* connect Dex to **kubectl (k3s login)**
* integrate Dex with your **Python app (OIDC instead of LDAP)**
* add **Traefik ingress + HTTPS**
* map LDAP groups → Kubernetes RBAC

---

If you want, I can wire this into your Python auth system so you stop using LDAP directly 👍
