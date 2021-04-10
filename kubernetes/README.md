# Kubernetes

Aqui estão os manifestos do Kubernetes.

Comece criando o `lua.yml` pois contém o `namespace` seguido do `mariadb.yml`, após isso crie o secret para a aplicação:

```bash
kubectl apply -f lua.yml -f mariadb.yml
kubectl create secret generic -n lua lua --from-env-file app-secret.ini
```

> **Observação:** O `secret` foi criado apenas para a aplicação por questões de legibilidade.
