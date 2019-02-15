FROM davidcaste/alpine-java-unlimited-jce:jdk8

LABEL maintainer="Edward <zhw.js@icloud.com>"

ENV TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.3 \
    TOMCAT_HOME=/usr/local/tomcat \
    CATALINA_HOME=/usr/local/tomcat \
    CATALINA_OUT=/dev/null

RUN apk upgrade --update && \
    apk add --update curl && \
    curl -jksSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    gunzip /tmp/apache-tomcat.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat.tar && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${TOMCAT_HOME} && \
    rm -rf ${TOMCAT_HOME}/webapps/* && \
    apk del curl && \
    rm -rf /tmp/* /var/cache/apk/*

COPY catalina.properties ${TOMCAT_HOME}/conf/catalina.properties
# COPY server.xml ${TOMCAT_HOME}/conf/server.xml
WORKDIR $CATALINA_HOME
# VOLUME ["/logs"]
RUN set -x \
    && echo "JAVA_OPTS='-Xms1024m -Xmx2048m'" > bin/setenv.sh

EXPOSE 8080

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]