FROM debian:jessie

RUN apt-get update
RUN apt-get install -y redis-server php5-cli php5-redis net-tools bash vim tcpdump telnet
ADD ./ /opt/kv-inj/

CMD /etc/init.d/redis-server start && php /opt/kv-inj/fuzz.php
