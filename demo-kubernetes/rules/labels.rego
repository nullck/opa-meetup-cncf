package kubernetes.admission

operations = {"CREATE", "UPDATE"}

# it's required to set labels in a pod resource
deny[msg] {
  resource_kind := input.request.kind.kind
  re_match(`^(Pod|Deployment|ReplicaSet|DaemonSet)`, resource_kind)
  not input.request.object.metadata.labels
  msg = "please set the labels costCenter, app and environment"
}

deny[msg] {
  resource_kind := input.request.kind.kind
  re_match(`^(Pod|Deployment|ReplicaSet|DaemonSet)`, resource_kind)
  labels := input.request.object.metadata.labels
  check_labels(labels)
  msg = "please set the labels costCenter, app and environment"
}

# it's required to set the label owner on Namespace resource, for infra cost tracking
deny[msg] {
  input.request.kind.kind = "Namespace"
  not input.request.object.metadata.labels.owner
  msg = "Please set the Owner label on the Namespace resource. The value must be the name of the team/project that owns the namespace - https://yaradigitalfarming.atlassian.net/l/c/VdfFdAr1"
}

check_labels(labels) {
  not labels.environment
}

check_labels(labels) {
  not labels.app
}
