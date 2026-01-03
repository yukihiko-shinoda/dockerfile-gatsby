variable "DOCKER_TAG" {
}
target "gatsby" {
  tags = [
    "futureys/gatsby:latest",
    "futureys/gatsby:${DOCKER_TAG}",
  ]
}
// To prevent following error when testing `docker buildx bake` in development PC:
//   ERROR: Multi-platform build is not supported for the docker driver.
//   Switch to a different driver, or turn on the containerd image store, and try again.
//   Learn more at https://docs.docker.com/go/build-multi-platform/
target "app-release" {
  inherits = ["gatsby"]
  platforms = ["linux/amd64", "linux/arm64"]
}
