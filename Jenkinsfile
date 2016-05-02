
node("docker") {
  stage 'build'
  docker.build('slushpupie/artifactory').push()
}

