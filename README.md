# Artifactory

Run [Artifactory](http://www.jfrog.com/home/v_artifactory_opensource_overview) inside a Docker container.

Link: [mattgruter/artifactory](https://registry.hub.docker.com/u/mattgruter/artifactory/)


## Volumes
Artifactories `data`, `logs` and `backup` directories are exported as volumes:

    /artifactory/data
    /artifactory/logs
    /artifactory/backup

## Ports
The web server is accessible through port `8080`.

## Example
To run artifactory do:

    docker run -p 8080:8080 mattgruter/artifactory

Now point your browser to http://localhost:8080


## URLs
The artifactory servlet is available at the `artifactory/` path. However a filter redirects all paths outside of `artifactory/` to the artifactory servlet. Thus instead of linking to the URL http://localhost:8080/artifactory/libs-release-local you can just link to http://localhost:8080/libs-release-local (i.e. omitting the subpath `artifactory/`).

## Runtime options
Inject the environment variable `RUNTIME_OPTS` when starting a container to set Tomcat's runtime options (i.e. `CATALANA_OPTS`). The most common use case is to set the heap size:

    docker run -e RUNTIME_OPTS="-Xms256m -Xmx512m" -P mattgruter/artifactory

## Switching to Artifactory Pro
If you are using Artifactory Pro, the artifactory war archive has to be replaced. The image tagged `-onbuild` is built with an `ONBUILD` trigger for this purpose. Unpack the Artifactory Pro distribution ZIP file and place the file `artifactory.war` (located in the archive) in the same directory as a simple Dockerfile that extends the `onbuild` image:

    # Dockerfile for Artifactory Pro
    FROM mattgruter/artifactory:latest-onbuild

Now build your child docker image:

    docker build -t yourname/myartifactory .

The `ONBUILD` trigger ensures your `artifactory.war` is picked up and applied to the image upon build.

    docker run -P yourname/myartifactory

