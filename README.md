# log-sender (Fluentd in docker container)

Input

* rsyslog
  * 10514: syslog
  * 11514: nginx accesslog
  * 12514: uwsgi accesslog
* application
  * 10224,24224: actionlog

## build

```
sudo docker build -t bungoume/log-sender .
```

## boot

set ENV `TO_HOST=<log_aggregator_host>`

```
sudo docker run -e "TO_HOST=logserver.example.com" -v /var/run/docker.sock:/tmp/docker.sock -d bungoume/log-sender
```
