package kubernetes.admission

operations = {"CREATE", "UPDATE"}

deny[reason] {
  input_containers[container]
  check_image(container.image)
  reason := "container image refers to illegal registry (must be nullck)"
}

input_containers[container] {
  container := input.request.object.spec.containers[_]
}

input_containers[container] {
  container := input.request.object.spec.template.spec.containers[_]
}

check_image(image) {
  not re_match(`^(nullck|nodejs|banzaicloud\/(bank-vaults|vault-operator|vault-secrets-webhook))`, image)
}

