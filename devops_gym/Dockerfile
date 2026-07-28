FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo procps psmisc file adduser \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash juanes \
    && echo 'juanes ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/juanes

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh && /setup.sh

USER juanes
WORKDIR /home/juanes

CMD ["/bin/bash"]
