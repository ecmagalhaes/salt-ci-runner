FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl wget && \
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh && \
    sh bootstrap_salt.sh

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/
RUN mkdir -p /srv/salt && \
    mkdir -p /srv/pillar && \
    mkdir -p /srv/states
RUN echo "base:" > /srv/salt/top.sls && \
    echo "  '*':" >> /srv/salt/top.sls && \
    echo "    - states" >> /srv/salt/top.sls && \
    echo "    - pillar" >> /srv/salt/top.sls

RUN salt '*' saltutil.refresh_pillar
RUN salt-call --local state.highstate -l debug
