FROM debian:jessie
MAINTAINER Richard Challis/LepBase contact@lepbase.org

RUN apt-get update && apt-get install -y \
    git \
    lighttpd \
    php5-cgi \
    unzip \
    wget

RUN lighty-enable-mod fastcgi
RUN lighty-enable-mod fastcgi-php
COPY lighttpd.conf /etc/lighttpd/

ARG VERSION=0.28.1
RUN wget https://release.larsjung.de/h5ai/h5ai-$VERSION.zip
RUN mkdir -p /var/www
RUN unzip h5ai-$VERSION.zip -d /var/www/
RUN sed -i "s;\"hidden\": \[;\"hidden\": \[\"^/img\",\"^/html\",;" /var/www/_h5ai/private/conf/options.json
RUN mkdir /conf
COPY startup.sh /
EXPOSE 8080
WORKDIR /var/www/html
ARG CACHEBUSTER=156725123
RUN git clone https://github.com/rjchallis/assembly-stats
RUN git clone https://github.com/rjchallis/codon-usage
CMD /startup.sh
