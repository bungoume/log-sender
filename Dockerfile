FROM alpine:3.10

RUN apk --no-cache --update add \
                            build-base \
                            ca-certificates \
                            openssl \
                            ruby \
                            ruby-irb \
                            ruby-etc \
                            ruby-webrick \
                            ruby-dev && \
    echo 'gem: --no-document' >> /etc/gemrc && \
    gem install oj json && \
    gem install fluentd -v 1.7.4 && \
    gem install fluent-plugin-beats && \
    apk del build-base ruby-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /usr/lib/ruby/gems/*/cache/*.gem

RUN mkdir -p /etc/fluent/plugin && mkdir -p /data/buffer && mkdir /data/pos && mkdir /data/log
COPY plugin /etc/fluent/plugin/

ENV DOCKERIZE_VERSION v0.6.1

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


COPY . /app/
WORKDIR /app/

EXPOSE 10224
EXPOSE 10514/udp
EXPOSE 5044

ENV TO_HOST logserver.example.com
ENV APP_NAME noname

CMD ["dockerize", "-template", "/app/fluent.tmpl:/etc/fluent/fluent.conf", "fluentd"]
