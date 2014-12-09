FROM tomcat:7-jre7

MAINTAINER Matthias Grüter <matthias@grueter.name>

# Disable Tomcat's manager application.
RUN rm -rf webapps/*

# Redirect to the Artifactory servlet from root.
RUN mkdir webapps/ROOT
RUN echo '<html><head><meta http-equiv="refresh" content="0;URL=artifactory/"></head><body></body></html>' > webapps/ROOT/index.html

# Fetch and install Artifactory OSS war archive.
RUN \
  wget -v https://bintray.com/artifact/download/jfrog/artifactory/artifactory-3.4.2.zip -O artifactory.zip && \
  unzip -j artifactory.zip "artifactory-*/webapps/artifactory.war" -d webapps && \
  rm artifactory.zip

# Add hook to install custom artifactory.war (i.e. Artifactory Pro) to replace the default OSS installation.
ONBUILD ADD ./artifactory.war webapps/

# Expose tomcat runtime options through the RUNTIME_OPTS environment variable.
#   Example to set the JVM's max heap size to 256MB use the flag
#   '-e RUNTIME_OPTS="-Xmx256m"' when starting a container.
RUN echo 'export CATALINA_OPTS="$RUNTIME_OPTS"' > bin/setenv.sh

# Artifactory home
RUN mkdir -p /artifactory
ENV ARTIFACTORY_HOME /artifactory

# Expose Artifactories data, log and backup directory.
VOLUME /artifactory/data
VOLUME /artifactory/logs
VOLUME /artifactory/backup

WORKDIR /artifactory
