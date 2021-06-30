FROM fluent/fluent-bit:1.7

RUN mkdir -p /data/log

COPY fluent-bit.conf /app/fluent-bit.conf

EXPOSE 10224
EXPOSE 10514/udp

ENV TO_HOST logserver.example.com
ENV APP_NAME noname

CMD ["/fluent-bit/bin/fluent-bit", "-c", "/app/fluent-bit.conf"]
