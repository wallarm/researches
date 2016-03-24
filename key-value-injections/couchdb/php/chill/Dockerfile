FROM couchdb:latest 

RUN apt-get update && apt-get install -y wget telnet tcpdump netcat curl make tar git vim php5-cli 

ADD ./ /opt/kv-inj/

RUN cd /opt/kv-inj/ && git clone git://github.com/Block8/Chill

CMD /etc/init.d/redis-server start && php /opt/kv-inj/fuzz.php
