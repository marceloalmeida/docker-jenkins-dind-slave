FROM ubuntu:14.04

MAINTAINER Marcelo Almeida <marcelo.almeida@jumia.com>

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    git \
    zip \
    supervisor \
    default-jre-headless && \
    rm -rf /var/lib/apt/lists/*

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the wrapper script from https://raw.githubusercontent.com/docker/docker/master/hack/dind.
ADD ./dind /usr/local/bin/dind
RUN chmod +x /usr/local/bin/dind

ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker

ENV DOCKER_COMPOSE_VERSION 1.7.0

ENV JENKINS_HOME /var/lib/jenkins
RUN \
  mkdir ${JENKINS_HOME} && \
  useradd jenkins --home-dir ${JENKINS_HOME} && \
  chown jenkins:jenkins ${JENKINS_HOME} && \
  usermod -a -G docker jenkins

# Install Docker Compose
RUN curl -s -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Download Jenkins Swarm plugin
ENV SWARM_VERSION 2.2
ADD https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar /root/swarm-client-jar-with-dependencies.jar

ENV \
  URL="" \
  USERNAME="" \
  PASSWORD="" \
  FSROOT="/var/lib/jenkins/" \
  EXECUTORS="1"

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
