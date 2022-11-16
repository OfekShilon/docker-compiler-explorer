FROM madduci/docker-linux-cpp:latest

LABEL maintainer="Michele Adduci <adduci@tutanota.com>" \
      license="Copyright (c) 2012-2022, Matt Godbolt"

EXPOSE 10240

RUN echo "*** Installing Compiler Explorer ***" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y \
        wget \
        ca-certificates \
        nodejs \
        openssh-client \
        make \
        git \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/*

# Create known_hosts and add github key, to enable no-interaction clone
RUN mkdir /root/.ssh \
    && touch /root/.ssh/known_hosts \
    && ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN git clone https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer

RUN cd /compiler-explorer \
    && echo "Add missing dependencies" \
    && npm i @sentry/node \
    && npm run webpack

ADD cpp.properties /compiler-explorer/etc/config/c++.local.properties

WORKDIR /compiler-explorer

ENTRYPOINT [ "make" ]

CMD ["run"]
