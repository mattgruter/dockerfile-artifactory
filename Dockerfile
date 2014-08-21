FROM tutum/tomcat:7.0

MAINTAINER Matthias Grüter <matthias@grueter.name>

# Disable debconf frontend warnings.
ENV DEBIAN_FRONTEND noninteractive

# Unzip is needed to install Artifactory.
# (we first need to recreate the apt package index as it has been removed from the base image)
RUN apt-get update && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

# Disable Tomcat's manager application.
RUN rm -rf /tomcat/webapps/*

# Redirect to the Artifactory servlet from root.
RUN mkdir /tomcat/webapps/ROOT
RUN echo '<html><head><meta http-equiv="refresh" content="0;URL=artifactory/"></head><body></body></html>' > /tomcat/webapps/ROOT/index.html

# Fetch and install Artifactory OSS war archive.
RUN \
  wget --quiet http://dl.bintray.com/jfrog/artifactory/artifactory-3.3.0.zip -O artifactory.zip && \
  unzip -j artifactory.zip "artifactory-*/webapps/artifactory.war" -d /tomcat/webapps && \
  rm artifactory.zip

# Add hook to install custom artifactory.war (i.e. Artifactory Pro) to replace the default OSS installation.
ONBUILD ADD ./artifactory.war /tomcat/webapps/

# Expose tomcat runtime options through the RUNTIME_OPTS environment variable.
#   Example to set the JVM's max heap size to 256MB use the flag
#   '-e RUNTIME_OPTS="-Xmx256m"' when starting a container.
RUN echo 'export CATALINA_OPTS="$RUNTIME_OPTS"' > /tomcat/bin/setenv.sh

# Artifactory home
RUN mkdir -p /artifactory
ENV ARTIFACTORY_HOME /artifactory

# Expose Artifactories data, log and backup directory.
VOLUME /artifactory/data
VOLUME /artifactory/logs
VOLUME /artifactory/backup

WORKDIR /artifactory
