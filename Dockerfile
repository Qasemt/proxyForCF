FROM nginx:mainline-alpine-slim

LABEL maintainer="qasemt@gmail.net"
LABEL version="0.1"
EXPOSE 8080

USER root

ENV myapp=/usr/local/myapp/ CFIPs=104.24.86.29




RUN mkdir -p $myapp


RUN apk update && \
    apk upgrade && \
    apk add --no-cache supervisor  wget curl openssl libqrencode  jq unzip tzdata bash nano 



COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh $myapp 


## INSTLL
##apk del wget unzip  && \
RUN chmod a+x "${myapp}entrypoint.sh" && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    echo "NGINX PROXY STREAM FOR CF ${CFIPs}" > ${myapp}info

WORKDIR $myapp
RUN sh  entrypoint.sh



CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]