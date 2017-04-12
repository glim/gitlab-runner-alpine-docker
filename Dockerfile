#FROM gitlab/gitlab-runner:alpine
FROM node:7-alpine
RUN apk add --update bash git curl openssh && rm -rf /var/cache/apk/* 
RUN curl -s https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz | tar -xzf - docker/docker -O  > /usr/bin/docker && chmod +x /usr/bin/docker
RUN curl -s -o /usr/local/bin/gitlab-ci-multi-runner https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-ci-multi-runner-linux-amd64 && chmod +x /usr/local/bin/gitlab-ci-multi-runner && ln -s /usr/local/bin/gitlab-ci-multi-runner /usr/bin/gitlab-runner && mkdir -p /etc/gitlab-runner
RUN adduser -h /home/gitlab-runner -s /bin/ash -D gitlab-runner && addgroup gitlab-runner ping
VOLUME /etc/gitlab-runner
COPY config.toml /etc/gitlab-runner/config.toml
CMD gitlab-ci-multi-runner run --user=gitlab-runner --working-directory=/home/gitlab-runner
RUN npm install -g coffee-script && rm -rf /root/.npm /root/.node-gyp
