
node("docker") {
  checkout scm
  stage 'build'
  docker.build('slushpupie/artifactory').push()
}

