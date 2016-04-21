# log-sender (Fluentd in docker container)

Input

* rsyslog
  * 10514: syslog
  * 11514: nginx accesslog (obsolete)
  * 12514: uwsgi accesslog (obsolete)
* file
  * /data/log/nginx_access.log
  * /data/log/nginx_error.log
  * /data/log/uwsgi_access.log
  * /data/log/nodejs_access.log
* application
  * 10224,24224: actionlog

## build

```
sudo docker build -t bungoume/log-sender .
```

## boot

set ENV `TO_HOST=<log_aggregator_host>`

```
sudo docker run -e "TO_HOST=logserver.example.com" -v /var/run/docker.sock:/var/run/docker.sock:ro -d bungoume/log-sender
```
