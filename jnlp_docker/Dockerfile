FROM jenkins/inbound-agent:alpine

USER root

# Alpine seems to come with libcurl baked in, which is prone to mismatching
# with newer versions of curl. The solution is to upgrade libcurl.
RUN apk update && apk add -u libcurl curl
# Install Docker client
ARG DOCKER_VERSION=18.03.0-ce
ARG DOCKER_COMPOSE_VERSION=1.21.0
RUN curl -fsSL https://download.docker.com/linux/static/stable/`uname -m`/docker-$DOCKER_VERSION.tgz | tar --strip-components=1 -xz -C /usr/local/bin docker/docker
RUN curl -fsSL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN wget https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v2.1.0/docker-credential-gcr_linux_amd64-2.1.0.tar.gz 
RUN tar -xf docker-credential-gcr_linux_amd64-2.1.0.tar.gz
RUN mv ./docker-credential-gcr /usr/bin/docker-credential-gcr



# add to shell script     docker-credential-gcr configure-docker --registries="gcr.io" && docker-credential-gcr config --token-source="env"
RUN apk update && apk add openrc docker
RUN rc-update add docker boot
# RUN usermod -a -G docker jenkins
RUN touch /debug-flag

