# Artifactory

Run [Artifactory](http://www.jfrog.com/home/v_artifactory_opensource_overview) inside a Docker container.

Link: [mattgruter/artifactory](https://registry.hub.docker.com/u/mattgruter/artifactory/)


## Volumes
Artifactories data, logs and backup directories are exported as volumes:

  /artifactory/data
  /artifactory/logs
  /artifactory/backup

## Ports
Artifactory is accessible through port 8081.

## Example
To run an artifactory container simply write:
    
    docker run -P mattgruter/artifactory

## Switching from Artifactory OSS to Artifactory Pro
If you are using Artifactory Pro, the artifactory war archive has to be replaced. The Dockerfile includes `ONBUILD` triggers for this purpose. Rename the artifactory distribution ZIP to `artifactory.zip` and create a simple Dockerfile in the same directory:

    FROM mattgruter/artifactory

Now build your child docker image.

    docker build -t yourname/myartifactory

The `ONBUILD` triggers make sure that your `artifactory.zip` is picked up and applied to the image before execution.

    docker run -P yourname/myartifactory


