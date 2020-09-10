package kubernetes.admission

import data.kubernetes.namespaces

operations = {"DELETE"}

deny[msg] {
    input.request.kind.kind == "Namespace"
    input.request.operation = "DELETE"
    not namespaces[input.request.namespace].metadata.annotations["deletion"]
    msg := "Namespaces to be deleted needs to have the annotation deletion=yes"
}

