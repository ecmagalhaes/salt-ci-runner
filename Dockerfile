FROM ubuntu:16.04

ADD run_salt.sh /root/run_salt.sh

RUN apt-get update && apt-get install -y curl wget && \
    curl -L https://bootstrap.saltstack.com -o install_salt.sh && \
    sh install_salt.sh -P -M && chmod a+x /root/run_salt.sh

CMD ["/root/run_salt.sh"]