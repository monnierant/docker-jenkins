FROM jenkins/jenkins:lts

LABEL maintainer="Antoine Monnier"

# if we want to install via apt
USER root
RUN apt-get update && apt-get install -y php7.3

ADD https://getcomposer.org/installer /tmp/install-composer.php
RUN php /tmp/install-composer.php --no-ansi --install-dir=/usr/bin --filename=composer
RUN composer --ansi --version --no-interaction
RUN rm /tmp/install-composer.php

# drop back to the regular jenkins user - good practice
USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state