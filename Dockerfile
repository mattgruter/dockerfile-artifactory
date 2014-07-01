FROM dockerfile/java 

MAINTAINER Matthias Grüter <matthias@grueter.name>

# Reset workdir to /
WORKDIR /

# Fetch and install Artifactory OSS.
RUN \
  wget --quiet http://dl.bintray.com/jfrog/artifactory/artifactory-3.2.2.zip -O artifactory.zip && \
  unzip artifactory.zip && \
  rm artifactory.zip && \
  mv artifactory-* artifactory

# Add hooks to install custom artifactory.zip (i.e. Artifactory Pro) over the default OSS installation.
ONBUILD ADD ./artifactory.zip /newartifactory/
ONBUILD RUN \
  unzip /newartifactory/artifactory.zip -d /newartifactory && \
  mv /newartifactory/artifactory-*/webapps/artifactory.war /artifactory/webapps/artifactory.war && \
  rm -rf /newartifactory

# Make memory settings overridable with environment variables.
# Override with -e MEM_INIT=... and -e MEM_MAX=... when starting a container.
RUN sed -i -e 's/Xms512m/Xms${MEM_INIT-512m}/g' -e 's/Xmx2g/Xmx${MEM_MAX-2g}/g' artifactory/bin/artifactory.default

# Expose Artifactories data directory (database & artifacts)
VOLUME /artifactory/data
VOLUME /artifactory/logs
VOLUME /artifactory/backup

# Default port to Artifactories web interface.
EXPOSE 8081 

WORKDIR /artifactory

CMD ["/artifactory/bin/artifactory.sh"]

