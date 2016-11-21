FROM alpine:3.4

RUN apk --no-cache --update add \
                            build-base \
                            ca-certificates \
                            openssl \
                            ruby \
                            ruby-irb \
                            ruby-dev && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install oj json foreman && \
    gem install fluentd -v "~> 0.14.0" && \
    apk del build-base ruby-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem

RUN mkdir -p /etc/fluent/plugin && mkdir -p /data/buffer && mkdir /data/pos && mkdir /data/log
COPY plugin /etc/fluent/plugin/

ENV DOCKER_GEN_VERSION 0.7.3

RUN wget https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
    tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
    rm /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz


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
