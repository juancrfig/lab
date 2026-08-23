#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

docker build -t gym/devops-lab .
name="devops-lab-$RANDOM-$$"
cleanup() {
  docker rm -f "$name" >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

# systemd runs as PID 1 so service tickets use the real systemctl/journalctl.
# The same disposable privileged container mounts the small disk-bloat tmpfs.
docker run -d --rm --privileged --cgroupns=host \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --name "$name" --hostname devops-lab --user root gym/devops-lab >/dev/null

for _ in {1..50}; do
  docker exec "$name" systemctl is-system-running --wait >/dev/null 2>&1 && break
  sleep 0.1
done

# login records the interactive session, making who, w, and last meaningful.
docker exec -it --user root "$name" login -f juanes
