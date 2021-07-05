package kubernetes.admission

operations = {"CREATE", "UPDATE"}

# it's required to set labels in a pod resource
deny[msg] {
  resourceInput := input.request.kind.kind
  re_match(`^(Pod|Deployment|ReplicaSet|DaemonSet)`, resourceInput)
  input.request.operation = "CREATE"
  not input.request.object.metadata.labels
  msg = "please set the labels costCenter, app and environment"
}

deny[msg] {
  resourceInput := input.request.kind.kind
  re_match(`^(Pod|Deployment|ReplicaSet|DaemonSet)`, resourceInput)
  input.request.operation = "CREATE"
  labels := input.request.object.metadata.labels
  check_labels(labels)
  msg = "please set the labels costCenter, app and environment"
}

deny[msg] {
  resourceInput := input.request.kind.kind
  re_match(`^(Deployment|ReplicaSet|DaemonSet)`, resourceInput)
  input.request.operation = "CREATE"
  not input.request.object.spec.template.metadata.labels
  msg = "please set the labels costCenter, app and environment in the pod level"
}

deny[msg] {
  resourceInput := input.request.kind.kind
  re_match(`^(Deployment|ReplicaSet|DaemonSet)`, resourceInput)
  labels := input.request.object.spec.template.metadata.labels
  check_labels(labels)
  msg = "please set the labels costCenter, app and environment in the pod level"
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

