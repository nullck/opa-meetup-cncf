#!/bin/bash

if [ -z $1 ]; then
  echo "use a parameter like install, opa or destroy"
  exit 0
fi

CLUSTER_NAME="opa"
CREATE_REGO="kubectl create configmap"
KIND_V="1-18"

if [ "$1" == "install" ]; then
  kind create cluster --name ${CLUSTER_NAME} --config kind-${KIND_V}.yaml

elif [ "$1" == "opa" ]; then

  ## ignore the namespaces kube-system and opa
  kubectl create ns opa
  kubectl label ns kube-system openpolicyagent.org/webhook=ignore
  kubectl label ns opa openpolicyagent.org/webhook=ignore

  ## rego rules
  $CREATE_REGO default -n opa --from-file=rules/default.rego
  $CREATE_REGO labels -n opa --from-file=rules/labels.rego
  $CREATE_REGO protect-namespace -n opa --from-file=rules/protect-namespace.rego
  $CREATE_REGO register-image -n opa --from-file=rules/register-image.rego
  kubectl -n opa label configmap/default openpolicyagent.org/policy=rego
  kubectl -n opa label configmap/labels openpolicyagent.org/policy=rego
  kubectl -n opa label configmap/protect-namespace openpolicyagent.org/policy=rego
  kubectl -n opa label configmap/register-image openpolicyagent.org/policy=rego

elif [ "$1" == "destroy" ]; then
  kind delete cluster --name ${CLUSTER_NAME}
fi

exit 0
