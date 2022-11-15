FROM openjdk:8-jre-slim
ARG JMETER_VERSION=${JMETER_VERSION:-5.5}

ENV JMETER_HOME /jmeter/apache-jmeter-$JMETER_VERSION/
ENV PATH $JMETER_HOME/bin:$PATH

# INSTALL PRE-REQ
RUN apt-get update && apt-get -y install \
    wget \
    zip \
    curl \
    && rm -rf /var/lib/apt/lists/*


# INSTALL JMETER BASE
WORKDIR /jmeter

RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz && \
    tar -xzf apache-jmeter-$JMETER_VERSION.tgz && \
    rm apache-jmeter-$JMETER_VERSION.tgz && \
    mkdir /jmeter-plugins && \
    cd /jmeter-plugins/ && \
    wget https://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.4.0.zip && \
    unzip -o JMeterPlugins-ExtrasLibs-1.4.0.zip -d /jmeter/apache-jmeter-$JMETER_VERSION

WORKDIR $JMETER_HOME

ADD config/user.properties bin/user.properties
ADD config/docker-entrypoint.sh /docker-entrypoint.sh
ADD config/log4j2.xml bin/log4j2.xml

RUN chmod +x /docker-entrypoint.sh


EXPOSE 6000 1099 50000
ENTRYPOINT ["/docker-entrypoint.sh"]