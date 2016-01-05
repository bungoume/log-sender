FROM ruby:2.2

RUN gem install fluentd foreman

RUN mkdir -p /etc/fluent/plugin && mkdir -p /data/buffer && mkdir -p /data/pos
COPY plugin /etc/fluent/plugin/

ENV DOCKER_GEN_VERSION 0.4.3

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz


COPY . /app/
WORKDIR /app/

EXPOSE 10224
EXPOSE 10514/udp
EXPOSE 11514/udp
EXPOSE 12514/udp

ENV DOCKER_HOST unix:///var/run/docker.sock
ENV TO_HOST logserver.example.com
ENV APP_NAME noname

CMD ["foreman", "start"]
