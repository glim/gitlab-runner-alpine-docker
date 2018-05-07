#FROM gitlab/gitlab-runner:alpine
FROM node:8-alpine
RUN apk add --update bash git curl openssh-client && rm -rf /var/cache/apk/*
RUN curl -s https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xzf - docker/docker -O  > /usr/bin/docker && chmod +x /usr/bin/docker
RUN curl -s -o /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 && chmod +x /usr/local/bin/gitlab-runner && ln -s /usr/local/bin/gitlab-runner /usr/bin/gitlab-runner && mkdir -p /etc/gitlab-runner
RUN adduser -h /home/gitlab-runner -s /bin/ash -D gitlab-runner && addgroup gitlab-runner ping
VOLUME /etc/gitlab-runner
COPY config.toml /etc/gitlab-runner/config.toml
CMD /bin/ash -c "(grep -Fq 'runners' /etc/gitlab-runner/config.toml || gitlab-runner register) && gitlab-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner"
RUN npm install -g coffeescript && rm -rf /root/.npm /root/.node-gyp
COPY stack-fix.c /lib/
RUN set -ex \
    && apk add --no-cache  --virtual .build-deps build-base \
    && gcc  -shared -fPIC /lib/stack-fix.c -o /lib/stack-fix.so \
    && apk del .build-deps
ENV LD_PRELOAD /lib/stack-fix.so
