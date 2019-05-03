FROM ubuntu:bionic
MAINTAINER Richard Challis/LepBase contact@lepbase.org

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    git \
    lighttpd \
    php7.2-cgi \
    unzip \
    wget

RUN lighty-enable-mod fastcgi && \
    lighty-enable-mod fastcgi-php
COPY lighttpd.conf /etc/lighttpd/

ARG VERSION=0.29.2
RUN mkdir -p /var/www && \
    wget https://release.larsjung.de/h5ai/h5ai-$VERSION.zip && \
    unzip h5ai-$VERSION.zip -d /var/www/ && \
    sed -i "s;\"hidden\": \[;\"hidden\": \[\"cgi-bin\",\"^/img\",\"^/html\",;" /var/www/_h5ai/private/conf/options.json

RUN mkdir /conf
COPY startup.sh /
EXPOSE 8080
WORKDIR /var/www/html
ARG CACHEBUSTER=156725123
RUN git clone https://github.com/rjchallis/assembly-stats && \
    git clone https://github.com/rjchallis/codon-usage
CMD /startup.sh
