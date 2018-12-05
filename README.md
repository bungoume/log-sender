# log-sender (Fluentd in docker container)

Input

* rsyslog
  * 10514: syslog
* file
  * /data/log/nginx_access.log
  * /data/log/nginx_error.log
  * /data/log/uwsgi_access.log
  * /data/log/gunicorn_access.log
  * /data/log/nodejs_access.log
* application
  * 10224,24224: actionlog
* beats
  * 5044: beats

## build

```
sudo docker build -t bungoume/log-sender .
```

## boot

set ENV `TO_HOST=<log_aggregator_host>`

```
sudo docker run -e "TO_HOST=logserver.example.com" -d bungoume/log-sender
```
