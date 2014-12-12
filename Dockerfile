FROM tomcat:7-jre7

# Based on https://github.com/mattgruter/dockerfile-artifactory
#MAINTAINER Matthias Grüter <matthias@grueter.name>
MAINTAINER Stian Soiland-Reyes <soiland-reyes@cs.manchester.ac.uk>

# To update, check https://bintray.com/jfrog/artifactory/artifactory/view
ENV ARTIFACTORY_VERSION 3.4.2
ENV ARTIFACTORY_SHA1 394258c5fc8beffd60de821b6264660f5464b943

# Disable Tomcat's manager application.
RUN rm -rf webapps/*

# Redirect to the Artifactory servlet from root.
RUN mkdir webapps/ROOT
RUN echo '<html><head><meta http-equiv="refresh" content="0;URL=artifactory/"></head><body></body></html>' > webapps/ROOT/index.html

# Fetch and install Artifactory OSS war archive.


RUN \
  echo $ARTIFACTORY_SHA1 artifactory.zip > artifactory.zip.sha1 && \
  curl -L -o artifactory.zip https://bintray.com/artifact/download/jfrog/artifactory/artifactory-${ARTIFACTORY_VERSION}.zip && \
  sha1sum -c artifactory.zip.sha1 && \
  unzip -j artifactory.zip "artifactory-*/webapps/artifactory.war" -d webapps && \
  rm artifactory.zip


# Expose tomcat runtime options through the RUNTIME_OPTS environment variable.
#   Example to set the JVM's max heap size to 256MB use the flag
#   '-e RUNTIME_OPTS="-Xmx256m"' when starting a container.
RUN echo 'export CATALINA_OPTS="$RUNTIME_OPTS"' > bin/setenv.sh

# Artifactory home
RUN mkdir -p /artifactory
ENV ARTIFACTORY_HOME /artifactory


# Configure to use mysql 
# https://www.jfrog.com/confluence/display/RTF/MySQL
 
ADD http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar lib/

ADD http://subversion.jfrog.org/artifactory/public/trunk/distribution/standalone/src/main/install/misc/db/mysql.properties /artifactory/etc/storage.properties
# but change localhost to mysql for mySQL container --link
RUN sed -i s/localhost/mysql/ /artifactory/etc/storage.properties

# In case the above mysql.properties becomes unavailable:
#ADD mysql.properties /artifactory/etc/storage.properties


# Expose Artifactories data, log and backup directory.
VOLUME /artifactory/data
VOLUME /artifactory/logs
VOLUME /artifactory/backup

WORKDIR /artifactory
