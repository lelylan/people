FROM debian:7
MAINTAINER Federico Gonzalez <https://github.com/fedeg>

# Install packages
RUN apt-get update -qq \
 && apt-get install -y procps curl ruby-dev libsqlite3-dev ruby1.9.3 make git build-essential libxml2 zlib1g-dev liblzma-dev patch libxml2-dev libxslt-dev pkg-config libgmp-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install dependencies
RUN gem install bundler therubyracer execjs

# Install nodejs
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done
ENV NODE_VERSION 0.10.46
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Generate folders
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy files and install
ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
ADD config* /usr/src/app/
RUN bundle install
ADD . /usr/src/app

CMD [ "foreman", "start" ]
