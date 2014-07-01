FROM dockerfile/java 

MAINTAINER Matthias Grüter <matthias@grueter.name>

ADD http://dl.bintray.com/jfrog/artifactory/artifactory-3.2.2.zip
RUN unzip artifactory-*.zip
VOLUME /var
EXPOSE 8081 

CMD ["artifactory-*/bin/artifactory.sh"]

