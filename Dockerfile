FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl git && \
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh && \
    sh bootstrap_salt.sh && \
    mkdir -p /opt/salt/base && \
    mkdir -p /opt/salt/base{pillar,states,stack} && \
    echo "file_client: local" > /etc/salt/minion.d/minion.conf && \
    echo "pillar_roots:" > /etc/salt/minion.d/pillar_roots.conf && \
    echo "  base:" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "    - /opt/salt/base/pillar" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "file_roots:" > /etc/salt/minion.d/file_roots.conf && \
    echo "  base:" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/states" >> /etc/salt/minion.d/file_roots.conf && \
    echo "top_file_merging_strategy: same" >> /etc/salt/minion.d/file_roots.conf

CMD ["/bin/bash"]

RUN salt-call --local -l debug service.restart salt-minion

RUN salt-call --local test.ping
