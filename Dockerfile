FROM centos:7

ENV container docker

# install SaltStack
RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm \
    && yum clean expire-cache \
    && yum install -y \
        git \
        salt-minion \
        vim

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/
ADD conf/pillar/top.sls /srv/pillar
RUN salt-call saltutil.refresh_pillar
RUN salt-call --local state.apply
