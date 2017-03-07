FROM gitlab/gitlab-runner:alpine
RUN wget -qO- https://get.docker.com/builds/Linux/x86_64/docker-17.03.0-ce.tgz | tar -xzf - docker/docker -O  > /usr/bin/docker && chmod +x /usr/bin/docker
