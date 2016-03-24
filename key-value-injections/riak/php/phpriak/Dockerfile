FROM debian:wheezy

RUN apt-get update
RUN apt-get -y install curl
RUN curl https://packagecloud.io/gpg.key | apt-key add -
RUN apt-get install -y apt-transport-https
RUN echo 'deb https://packagecloud.io/basho/riak/debian/ wheezy main' >> /etc/apt/sources.list
RUN echo 'deb-src https://packagecloud.io/basho/riak/debian/ wheezy main' >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y riak php5-cli git tcpdump vim telnet netcat procps php5-curl git php5-dev make libpcre3-dev

ADD ./ /opt/kv-inj/

RUN cd /opt/kv-inj/ &&  git clone git://github.com/php-riak/php_riak.git && cd php_riak && git submodule init && git submodule update
RUN cd /opt/kv-inj/php_riak/ && phpize && ./configure && make install

CMD /etc/init.d/riak start && php /opt/kv-inj/fuzz.php
