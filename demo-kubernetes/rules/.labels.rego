package kubernetes.admission

operations = {"CREATE", "UPDATE"}

# it's required to set labels in a pod resource
deny[msg] {
  resourceInput := input.request.kind.kind
  re_match(`^(Pod|Deployment|ReplicaSet|DaemonSet)`, resourceInput)
  not input.request.object.metadata.labels
  msg = "please set the labels costCenter, app and environment"
}

deny[msg] {
  resourceInput := input.request.kind.kind
  re_match(`^(Pod|Deployment|ReplicaSet|DaemonSet)`, resourceInput)
  labels := input.request.object.metadata.labels
  check_labels(labels)
  msg = "please set the labels costCenter, app and environment"
}

check_labels(labels) {
  not labels.costCenter
}

check_labels(labels) {
  not labels.environment
}

check_labels(labels) {
  not labels.app
}

