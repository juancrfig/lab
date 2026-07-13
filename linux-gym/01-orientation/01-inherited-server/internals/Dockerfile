FROM debian:bookworm

# Debian's Docker images exclude man pages via dpkg path filters. The stretch
# commands (id, env, last, su) must be man-discoverable, so drop the filter
# first and reinstall the packages that ship those pages.
RUN rm -f /etc/dpkg/dpkg.cfg.d/docker* && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        procps util-linux hostname man-db manpages less nano vim-tiny nmap && \
    apt-get install --reinstall -y coreutils util-linux login && \
    rm -rf /var/lib/apt/lists/*

COPY setup.sh mkutmp.pl brief.md report.md cheatsheet.md /tmp/build/
COPY check.sh /usr/local/bin/check

RUN chmod 755 /usr/local/bin/check && \
    bash /tmp/build/setup.sh && \
    rm -rf /tmp/build

USER dev
WORKDIR /home/dev
# Login shell so /etc/profile.d/deploy-env.sh loads DEPLOY_ENV.
CMD ["bash", "-l"]
