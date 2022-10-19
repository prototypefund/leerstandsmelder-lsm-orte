FROM ruby:2.7.6

# Initial setup
RUN \
  curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get update -yq && \
  apt-get install -y \
    apt-transport-https \
    apt-utils \
    build-essential \
    cmake \
    nodejs \
    software-properties-common \
    unzip \
    mariadb-client

# Install yarn
RUN \
  wget -q -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  apt-get update -yq && \
  apt-get install -y yarn

# Install Chrome
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update -yqqq && \
  apt-get install -y google-chrome-stable > /dev/null 2>&1 && \
  sed -i 's/"$@"/--no-sandbox "$@"/g' /opt/google/chrome/google-chrome

# Install chromedriver
RUN \
  wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/100.0.4896.20/chromedriver_linux64.zip && \
  unzip /tmp/chromedriver.zip chromedriver -d /usr/bin/ && \
  rm /tmp/chromedriver.zip && \
  chmod ugo+rx /usr/bin/chromedriver
