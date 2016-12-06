FROM debian:jessie-backports

MAINTAINER Marcelo Almeida <ms.almeida86@gmail.com>

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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install the wrapper script from https://raw.githubusercontent.com/docker/docker/master/hack/dind.
ADD https://raw.githubusercontent.com/docker/docker/master/hack/dind /usr/local/bin/dind
RUN chmod +x /usr/local/bin/dind

ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Define additional metadata for our image.
VOLUME /var/lib/docker

ENV JENKINS_HOME /var/lib/jenkins
RUN \
  mkdir ${JENKINS_HOME} && \
  useradd jenkins --home-dir ${JENKINS_HOME} && \
  chown jenkins:jenkins ${JENKINS_HOME} && \
  usermod -a -G docker jenkins

# Download Jenkins Swarm plugin
ENV SWARM_VERSION 2.2
ADD https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar /root/swarm-client-jar-with-dependencies.jar

ENV \
  URL="" \
  USERNAME="" \
  PASSWORD="" \
  FSROOT="/var/lib/jenkins/" \
  EXECUTORS="1" \
  GIT_TIMEOUT="60" \
  MAX_HEAP_SIZE="512m" \
  MAX_PERM_SIZE="2048m"

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
