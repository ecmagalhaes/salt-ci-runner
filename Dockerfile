FROM ubuntu:16.04

ADD run_salt.sh /root/run_salt.sh

RUN apt-get update && apt-get install -y curl wget && \
    curl -L https://bootstrap.saltstack.com -o install_salt.sh && \
    sh install_salt.sh -P -M && \
    echo "open_mode: True" > /etc/salt/master.d/master.conf && \
    echo "auto_accept: True" >> /etc/salt/master.d/master.conf && \
    chmod a+x /root/run_salt.sh

CMD ["/root/run_salt.sh"]