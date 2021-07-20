FROM alpine:3.6

MAINTAINER innovatorjapan <system@innovator.jp.net>

ARG version=1.14.69

RUN apk -v --update add jq  python3  py3-pip  ca-certificates  \
    && pip3 install awscli==${version} \
    && apk -v --purge del py3-pip \ 
    &&  rm -rf /var/cache/apk/* 

ADD aws-s3-deploy /bin

CMD ["/bin/sh"]