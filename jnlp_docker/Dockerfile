FROM jenkins/inbound-agent:4.10-3-alpine

USER root

# Alpine seems to come with libcurl baked in, which is prone to mismatching
# with newer versions of curl. The solution is to upgrade libcurl.
RUN apk update && apk add -u libcurl curl gettext libintl 

# && mv /usr/bin/envsubst /usr/local/sbin/envsubst

# Install Docker client
ARG DOCKER_VERSION=18.03.0-ce
ARG DOCKER_COMPOSE_VERSION=1.21.0
RUN curl -fsSL https://download.docker.com/linux/static/stable/`uname -m`/docker-$DOCKER_VERSION.tgz | tar --strip-components=1 -xz -C /usr/local/bin docker/docker
RUN curl -fsSL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Install docker-credential-gcr
RUN wget https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v2.1.0/docker-credential-gcr_linux_amd64-2.1.0.tar.gz 
RUN tar -xf docker-credential-gcr_linux_amd64-2.1.0.tar.gz
RUN mv ./docker-credential-gcr /usr/bin/docker-credential-gcr

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.1.3/terraform_1.1.3_linux_amd64.zip
RUN unzip terraform_1.1.3_linux_amd64.zip && rm terraform_1.1.3_linux_amd64.zip
RUN mv terraform /usr/bin/terraform
# add to shell script before "docker push"            docker-credential-gcr configure-docker --registries="gcr.io" && docker-credential-gcr config --token-source="env"


# # Install gcloud SDK
# RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
# RUN apk add -u python3 py3-pip
# RUN mkdir -p /usr/local/gcloud \
#   && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz 
# RUN chown jenkins /usr/local/gcloud -R
# USER jenkins
# RUN /usr/local/gcloud/google-cloud-sdk/install.sh
# USER root
# ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin


RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
    chmod +x ./kubectl &&\
    mv ./kubectl /usr/bin/kubectl    

RUN apk update && apk add openrc docker
RUN rc-update add docker boot
# RUN usermod -a -G docker jenkins
RUN touch /debug-flag \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*
 
# COPY sa-private-key.json /var/tmp/sa-private-key.json
# RUN chmod 777 /var/tmp/sa-private-key.json