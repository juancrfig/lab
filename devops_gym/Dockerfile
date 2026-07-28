FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN useradd -m -s /bin/bash juanes

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh && /setup.sh

USER juanes
WORKDIR /home/juanes

CMD ["/bin/bash"]
