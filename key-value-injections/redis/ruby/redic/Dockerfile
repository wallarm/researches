FROM debian:jessie

RUN apt-get update
RUN apt-get install -y redis-server ruby-dev ruby rubygems tcpdump vim telnet libc6-dev gcc
#RUN gem install redic

ADD ./ /opt/kv-inj/

CMD /etc/init.d/redis-server start && php /opt/kv-inj/fuzz.php
