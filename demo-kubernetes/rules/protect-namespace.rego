package kubernetes.admission

import data.kubernetes.namespaces

import input.request.object.metadata.annotations as annotations

operations = {"DELETE"}

deny[msg] {
  input.request.kind.kind = "Namespace"
  input.request.operation = "DELETE"
  annotations_check
  msg = "Namespaces to be deleted needs to have the annotation deletion=yes"
}

# Require an annotation deletion="yes" to allow namespace deletion
annotations_check {
  not namespaces[input.request.namespace].metadata.annotations["deletion"]
}

annotations_check {
  annotation = namespaces[input.request.namespace].metadata.annotations["deletion"]
  not annotation = "yes"
}

