FROM my-docker/ubuntu-base-image
MAINTAINER Ryan Washburn <rpwashburn@gmail.com>

ENV mudletVersion mudlet-3.0.0-delta-linux-x64-installer.run
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        libhunspell-1.3-0 \
	libyajl2 \
	libqt5opengl5 \
	libqt5multimedia5 \
	libqt5widgets5 \
	libqt5network5 \
	libglu1-mesa \
	libzip2 \
	libxext-dev \
        libxrender-dev \ 
        libxtst-dev \
        liblua5.1-0 && \
    rm -rf /var/lib/apt/lists/*
# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

COPY install.sh /opt/install.sh
RUN chmod +x /opt/install.sh
WORKDIR /download
RUN wget http://www.mudlet.org/download/${mudletVersion}
RUN chmod +x ${mudletVersion}
RUN cd /opt && ./install.sh
USER developer
ENV HOME /home/developer
CMD cd /opt/mudlet/bin && ./mudlet
