package kubernetes.admission

operations = {"CREATE", "UPDATE"}

deny[reason] {
  input_containers[container]
  not startswith(container.image, "nullck")
  reason := "container image refers to illegal registry (must be nullck)"
}

input_containers[container] {
  container := input.request.object.spec.containers[_]
}

input_containers[container] {
  container := input.request.object.spec.template.spec.containers[_]
}

