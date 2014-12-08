FROM tutum/tomcat:7.0

# Based on https://github.com/mattgruter/dockerfile-artifactory
#MAINTAINER Matthias Grüter <matthias@grueter.name>
MAINTAINER Stian Soiland-Reyes <soiland-reyes@cs.manchester.ac.uk>

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
  wget --quiet http://dl.bintray.com/jfrog/artifactory/artifactory-3.4.2.zip -O artifactory.zip && \
  unzip -j artifactory.zip "artifactory-*/webapps/artifactory.war" -d /tomcat/webapps && \
  rm artifactory.zip


# Expose tomcat runtime options through the RUNTIME_OPTS environment variable.
#   Example to set the JVM's max heap size to 256MB use the flag
#   '-e RUNTIME_OPTS="-Xmx256m"' when starting a container.
RUN echo 'export CATALINA_OPTS="$RUNTIME_OPTS"' > /tomcat/bin/setenv.sh

# Artifactory home
RUN mkdir -p /artifactory
ENV ARTIFACTORY_HOME /artifactory


# Configure to use mysql 
# https://www.jfrog.com/confluence/display/RTF/MySQL
 
ADD http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.34/mysql-connector-java-5.1.34.jar /tomcat/lib/

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
