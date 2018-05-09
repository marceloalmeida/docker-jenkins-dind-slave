# Jenkins DinD (Docker in Docker) Slave

[![Build Status](https://travis-ci.org/marceloalmeida/docker-jenkins-dind-slave.svg?branch=master)](https://travis-ci.org/marceloalmeida/docker-jenkins-dind-slave)

This Jenkins Docker image provides Docker inside itself, which allows you to run any Docker container in your Jenkins build script.

Because Docker container proivdes an isolated environment for running applications or tasks, which is perfect for any CI solution. This image is designed to run everything with Docker, so it doesn't pre-install any execution environment for any specific programming language. Instead, simply run the images you need from the public Docker Hub or your private Docker registry for your CI tasks.

This Docker image is based on [jpetazzo/dind](https://registry.hub.docker.com/u/jpetazzo/dind/) instead of the offical [Jenkins](https://registry.hub.docker.com/u/library/jenkins/). Supervisord is used to make sure everything has proper permission and lanuch in the right order. Morever, [Docker Compose](https://github.com/docker/compose) is available for launching multiple containers inside the CI.

Run:

```
docker run \
  --name jenkins-dind-slave \
  --privileged=true \
  --detach=true \
  -e URL=http://[jenkins_master_url]:8080 \
  -e USERNAME=username \
  -e PASSWORD=qwertyuiopasdfghjklzxcvbnm1234567890 \
  -e DOCKER_DAEMON_ARGS="--storage-driver=overlay2 --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375" \
  -v /lib/modules:/lib/modules:ro
marceloalmeida/jenkins-dind-slave
```
