FROM debian:jessie

RUN apt-get update
RUN apt-get install -y redis-server php5-cli net-tools bash vim tcpdump telnet git
ADD ./ /opt/kv-inj/

RUN cd /opt/kv-inj && git clone git://github.com/colinmollenhour/credis 

CMD /etc/init.d/redis-server start && php /opt/kv-inj/fuzz.php
