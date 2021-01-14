FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl wget && \
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh && \
    sh bootstrap_salt.sh

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/

# add top level states
ADD conf/salt /srv/salt

# add top level pillar
ADD conf/pillar /srv/pillar
