
node("docker") {
  checkout scm
  stage 'build'
  docker.build('localhost:6000/slushpupie/artifactory').push()
}

