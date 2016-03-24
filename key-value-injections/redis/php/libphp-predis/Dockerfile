FROM debian:jessie

RUN apt-get update
RUN apt-get install -y redis-server php5-cli libphp-predis tcpdump vim telnet

ADD ./ /opt/kv-inj/

CMD /etc/init.d/redis-server start && php /opt/kv-inj/fuzz.php
