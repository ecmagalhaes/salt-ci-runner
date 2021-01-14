FROM debian:8

# set local vars
ENV container docker
ENV LANG C.UTF-8
#ENV DEBIAN_FRONTEND noninteractive

# install dependencies
RUN sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -q systemd \
    curl \
    sudo \
    cron \
    dbus \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add SaltStack repo
ADD conf/saltstack.list /etc/apt/sources.list.d/saltstack.list

# install SaltStack
RUN curl https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    salt-minion

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/

RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
      rm -f /lib/systemd/system/multi-user.target.wants/*;\
      rm -f /etc/systemd/system/*.wants/*;\
      rm -f /lib/systemd/system/local-fs.target.wants/*; \
      rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
      rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
      rm -f /lib/systemd/system/basic.target.wants/*;\
      rm -f /lib/systemd/system/anaconda.target.wants/*; \
      rm -f /lib/systemd/system/plymouth*; \
      rm -f /lib/systemd/system/systemd-update-utmp*;

# set local vars
ENV init /lib/systemd/systemd

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]
