FROM jenkins/jenkins:lts

LABEL maintainer="Antoine Monnier"

# if we want to install via apt
USER root
RUN apt-get update && apt-get install -y php

COPY install-composer.sh /usr/local/bin/install-composer.sh
RUN chmod +x /usr/local/bin/install-composer.sh
RUN /usr/local/bin/install-composer.sh

# drop back to the regular jenkins user - good practice
USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state