From jenkins/jenkins:alpine

# Disabling the Setup Wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Add user and env to config
COPY casc.yaml /var/jenkins_home/casc.yaml
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# Manual installing terraform
USER root
RUN wget https://releases.hashicorp.com/terraform/1.1.2/terraform_1.1.2_linux_amd64.zip && \
    unzip terraform_1.1.2_linux_amd64.zip && rm terraform_1.1.2_linux_amd64.zip && \
    mv terraform /usr/bin/

COPY sa-private-key.json /home/jenkins/sa-private-key.json
