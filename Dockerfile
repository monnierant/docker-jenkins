FROM jenkins/jenkins:lts

LABEL maintainer="Antoine Monnier"

# if we want to install via apt
USER root
RUN apt-get update && apt-get install -y ca-certificates apt-transport-https
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
RUN echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get update && apt-get install -y php7.2 php7.2-cli php7.2-common php7.2-opcache php7.2-curl php7.2-mbstring php7.2-mysql php7.2-zip php7.2-xml

ADD https://getcomposer.org/installer /tmp/install-composer.php
RUN php /tmp/install-composer.php --no-ansi --install-dir=/usr/bin --filename=composer
RUN composer --ansi --version --no-interaction
RUN rm /tmp/install-composer.php

# drop back to the regular jenkins user - good practice
USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state