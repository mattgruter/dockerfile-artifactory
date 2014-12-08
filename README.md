# Artifactory with mySQL

Run [Artifactory](http://www.jfrog.com/home/v_artifactory_opensource_overview) inside a Docker container, linking to a mySQL container.

**Docker image:** [soilandreyes/artifactory](https://registry.hub.docker.com/u/soilandreyes/artifactory/)

This dockerfile is based on [mattgruter/artifactory](https://github.com/mattgruter/dockerfile-artifactory) by
[Matthias Grüter](http://www.matthias.grueter.name/).


## Volumes
Artifactory's `data`, `logs` and `backup` directories are exported as volumes:

    /artifactory/data
    /artifactory/logs
    /artifactory/backup

## Ports
The web server is accessible through port `8080`.

## Example

You will need to provide the image with a mySQL 5.5 server or newer. The simplest way to do this is using the
[mysql-tuned-for-artifactory](https://registry.hub.docker.com/u/soilandreyes/mysql-tuned-for-artifactory/) image:

    docker run --name mysql-for-artifactory soilandreyes/mysql-for-artifactory

Then run artifactory:

    docker run --name artifactory --link mysql-for-artifactory:mysql -p 8080:8080 soilandreyes/artifactory-with-mysql

Now point your browser to http://localhost:8080/ to use Artifactory.



## Runtime options
Inject the environment variable `RUNTIME_OPTS` when starting a container to set Tomcat's runtime options (i.e. `CATALANA_OPTS`). The most common use case is to set the heap size:

    docker run -e RUNTIME_OPTS="-Xms3g -Xmx4g" -P soilandreyes/artifactory-with-mysql

## Switching to Artifactory Pro
If you are using Artifactory Pro, the artifactory `war` archive has to be replaced. Unpack the Artifactory Pro distribution ZIP file and copy `webapps/artifactory.war` to a new directory. Then add this `Dockerfile`:

    # Dockerfile for Artifactory Pro
    FROM soilandreyes/artifactory-with-mysql
    ADD ./artifactory.war /tomcat/webapps

Now build your child docker image:

    docker build -t yourname/myartifactory

Run your image:

    docker run -P yourname/myartifactory

