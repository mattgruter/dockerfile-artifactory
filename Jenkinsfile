
node("docker") {
  checkout scm
  stage 'build'
  image = docker.build('localhost:6000/slushpupie/artifactory')
  stage 'publish'
  image.push()
}

