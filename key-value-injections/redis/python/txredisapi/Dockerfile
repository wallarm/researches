FROM debian:jessie

RUN apt-get update
RUN apt-get install -y redis-server tcpdump telnet vim python python-pip
#RUN gem install redic

ADD ./ /opt/kv-inj/

CMD /etc/init.d/redis-server start && php /opt/kv-inj/fuzz.php
