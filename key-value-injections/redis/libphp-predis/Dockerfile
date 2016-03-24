FROM debian:jessie

RUN apt-get update
RUN apt-get install -y redis-server php5 libphp-predis

ADD ./ /opt/kv-inj/

RUN php /opt/kv-inj/fuzz.php
