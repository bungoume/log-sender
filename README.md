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

## build

```
sudo docker build -t bungoume/log-sender .
```

## boot

set ENV `TO_HOST=<log_aggregator_host>`

```
sudo docker run -e "TO_HOST=logserver.example.com" -d bungoume/log-sender
```

## Recommended Formats

### nginx
```
log_format ltsv     "time:$time_iso8601\t"
                    "timestamp:$msec\t"
                    "remote_addr:$remote_addr\t"
                    "x_forwarded_for:$http_x_forwarded_for\t"
                    "x_forwarded_proto:$http_x_forwarded_proto\t"
                    "scheme:$scheme\t"
                    "method:$request_method\t"
                    "user:$remote_user\t"
                    "host:$host\t"
                    "path:$uri\t"
                    "query:$args\t"
                    # "req_body:$request_body\t"
                    "req_bytes:$request_length\t"
                    "connection:$connection\t"
                    "connection_requests:$connection_requests\t"
                    #"server_protocol:$server_protocol\t"
                    "referer:$http_referer\t"
                    #"cookie:$http_cookie\t"
                    "accept_language:$http_accept_language\t"
                    "user_agent:$http_user_agent\t"
                    "hostname:$hostname\t"
                    "status:$status\t"
                    "req_cache_control:$http_cache_control\t"
                    "res_cache_control:$sent_http_cache_control\t"
                    "res_bytes:$bytes_sent\t"
                    "res_body_bytes:$body_bytes_sent\t"
                    "res_content_encoding:$sent_http_content_encoding\t"
                    "res_content_type:$sent_http_content_type\t"
                    "location:$sent_http_location\t"
                    "etag:$sent_http_etag\t"
                    #"set_cookie:$sent_http_set_cookie\t"
                    "taken_time:$request_time\t"
                    "upstream_cache_status:$upstream_cache_status\t"
                    "upstream_addr:$upstream_addr\t"
                    "upstream_taken_time:$upstream_response_time";

log_not_found   off;
access_log /log/nginx_access.log  ltsv;
```

### apache

Apache httpd 2.4
```
<IfModule log_config_module>
<IfModule logio_module>
  # ( %q != req-query. ref: https://cl.hatenablog.com/entry/apache-customlog )
  #app_process:%P\t
  #cookie:%{Cookie}i\t
  #set_cookie:%{Set-Cookie}o\t

  LogFormat "\
time:%{%Y-%m-%dT%H:%M:%S}t.%{usec_frac}t%{%z}t\t\
remote_addr:%a\t\
x_forwarded_for:%{X-Forwarded-For}i\t\
x_forwarded_proto:%{X-Forwarded-Proto}i\t\
server_ip:%A\t\
method:%m\t\
user:%u\t\
host:%v\t\
path:%U\t\
query:%q\t\
referer:%{Referer}i\t\
accept_language:%{Accept-Language}i\t\
user_agent:%{User-Agent}i\t\
protocol:%H\t\
status:%>s\t\
req_cache_control:%{Cache-Control}i\t\
res_cache_control:%{Cache-Control}o\t\
res_content_encoding:%{Content-Encoding}o\t\
res_content_type:%{Content-Type}o\t\
location:%{Location}o\t\
etag:%{Etag}o\t\
req_bytes:%I\t\
res_bytes:%O\t\
res_body_bytes:%B\t\
taken_time_us:%D\t\
connection_status:%X\t\
req_first_line:%r" ltsv
  CustomLog "/log/apache_access.log" ltsv
</IfModule>
</IfModule>
```
