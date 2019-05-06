FROM ubuntu:16.04

LABEL maintainer="cezres <cezres@163.com>"

RUN apt-get update && apt-get install nginx -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
        && echo "daemon off;" >> /etc/nginx/nginx.conf

CMD ["nginx"]
