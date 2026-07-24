FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -m -s /bin/bash juanes && \
    echo 'juanes ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh

USER juanes
WORKDIR /home/juanes

CMD ["/bin/bash", "-c", "sudo /setup.sh && exec bash"]
