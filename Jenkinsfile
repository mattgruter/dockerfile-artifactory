
node("docker") {
  scm checkout
  stage 'build'
  docker.build('slushpupie/artifactory').push()
}

