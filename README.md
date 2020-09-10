### kubernetes demo

Instalar o Helmfile

https://github.com/roboll/helmfile/releases

Instalar o Helm 3

https://helm.sh/docs/intro/install/

Se quiser pode usar o arquivo kind-1-18.yaml e subir um cluster com o kind - https://kubernetes.io/docs/setup/learning-environment/kind/ , basta executar o script dentro do diretorio **demo-kubernetes**

```
bash setup.sh install
```

Para instalar o Opa, use o Helmfile

```
helmfile -f helmfile.yaml apply
```

Para instalar as regras do opa usadas na demo

```
bash setup.sh opa
```

Para destruir o cluster

```
bash setup.sh destroy
```

### terraform demo

Instalar o OPA:

https://github.com/open-policy-agent/opa/releases

dentro do diretorio **demo-terraform**

```terraform init
terraform plan --out tfplan.binary
```

**- convert binary to JSON**

```terraform show -json tfplan.binary > tfplan.json```

Resultado true, significa que não iremos ter alteração no recurso de IAM.

Vamos ver o score desse plan

```
opa eval --format pretty --data terraform.rego --input tfplan.json "data.terraform.analysis.score"
```

Resultado 11, significa:
10 para a criação do autoscaling e 1 para a criação da instancia
