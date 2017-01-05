FROM ubuntu:16.04
MAINTAINER Doro Wu <fcwu.tw@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# setup our Ubuntu sources (ADD breaks caching)

RUN apt update \
       && apt install -y  software-properties-common 
RUN add-apt-repository ppa:webupd8team/sublime-text-3
RUN add-apt-repository ppa:libreoffice/ppa

RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN apt update \
    && apt install -y --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        nodejs \
        libreoffice-gtk2 libreoffice-gnome firefox \
    && apt autoclean \
    && apt autoremove \
    && rm -rf /var/lib/apt/lists/*

ADD noVNC /noVNC/

ADD startup.sh /
ADD supervisord.conf /
EXPOSE 6080
EXPOSE 5900
EXPOSE 22
WORKDIR /

# Remove LibOffice
#RUN apt remove -y --purge libreoffice* libexttextcat-data* && sudo apt -y autoremove


ENTRYPOINT ["/startup.sh"]
