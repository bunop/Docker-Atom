
#
# VERSION 0.2
# DOCKER-VERSION  1.7.1
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    An atom container to work with atom
# TO_BUILD:       docker build --rm -t atom .
# TO_RUN:         docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY atom
# TO_TAG:         docker tag atom:latest atom:0.2
#

# I think is better to download a buildeb package insted of compile atom from source
# Starting from an image commonly used for build packages
FROM ubuntu:14.04

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

RUN apt-get update && apt-get install -y \
    wget \
    gdebi \
 && apt-get clean

# Download the last stable atom rmp package
RUN wget https://github.com/atom/atom/releases/download/v1.1.0/atom-amd64.deb -O /root/atom-amd64.deb

# install package with gdebi
RUN gdebi --non-interactive /root/atom-amd64.deb

# final clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/

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

CMD ["/usr/bin/atom", "--foreground"]
