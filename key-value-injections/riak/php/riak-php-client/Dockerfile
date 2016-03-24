FROM debian:wheezy

RUN apt-get update
RUN apt-get -y install curl
RUN curl https://packagecloud.io/gpg.key | apt-key add -
RUN apt-get install -y apt-transport-https
RUN echo 'deb https://packagecloud.io/basho/riak/debian/ wheezy main' >> /etc/apt/sources.list
RUN echo 'deb-src https://packagecloud.io/basho/riak/debian/ wheezy main' >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y riak php5-cli git tcpdump vim telnet netcat procps php5-curl

RUN curl -k https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php

ADD ./ /opt/kv-inj/

RUN cd /opt/kv-inj && git clone git://github.com/basho/riak-php-client 
RUN cd /opt/kv-inj/riak-php-client && php /composer.phar install

CMD /etc/init.d/riak start && php /opt/kv-inj/fuzz.php
