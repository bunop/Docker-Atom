#Based on work by Jessie Frazelle, https://github.com/jfrazelle/dockerfiles/blob/master/atom/Dockerfile
FROM ubuntu:14.04
MAINTAINER Andreas Mosti <andreas.mosti@gmail.com>

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    curl \
    git \
    libasound2 \
    libgconf-2-4 \
    libgnome-keyring-dev \
    libgtk2.0-0 \
    libnss3 \
    libxtst6 \
    --no-install-recommends

RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

RUN git clone https://github.com/atom/atom /src
WORKDIR /src
RUN git fetch && git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
RUN script/build && script/grunt install

# set up user and permission
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR $HOME 

# get my configfiles from github
RUN mkdir .atom &&  \ 
    git clone https://github.com/andmos/dotfiles.git && \ 
    cd dotfiles/atom; ./configureAtom


CMD /usr/local/bin/atom --foreground --log-file /var/log/atom.log && tail -f /var/log/atom.log
