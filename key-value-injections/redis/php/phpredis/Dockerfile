FROM debian:jessie

RUN apt-get update
RUN apt-get install -y redis-server php5-cli git net-tools bash vim tcpdump telnet php5-dev make
RUN cd /opt/ && \
	git clone git://github.com/phpredis/phpredis
RUN cd /opt/phpredis && \
	phpize && \
	./configure && \
	make && make install

ADD ./ /opt/kv-inj/

CMD /etc/init.d/redis-server start && php /opt/kv-inj/fuzz.php
