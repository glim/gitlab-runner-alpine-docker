#FROM gitlab/gitlab-runner:alpine
FROM node:8-alpine
RUN apk add --update bash git curl openssh-client && rm -rf /var/cache/apk/*
#RUN curl -s https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz | tar -xzf - docker/docker -O  > /usr/bin/docker && chmod +x /usr/bin/docker
RUN npm install -g coffee-script && rm -rf /root/.npm /root/.node-gyp
COPY stack-fix.c /lib/
RUN set -ex \
    && apk add --no-cache  --virtual .build-deps build-base \
    && gcc  -shared -fPIC /lib/stack-fix.c -o /lib/stack-fix.so \
    && apk del .build-deps
ENV LD_PRELOAD /lib/stack-fix.so
