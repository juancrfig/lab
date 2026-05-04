# Solutions

Open this only after you've tried. Compare — even if yours worked.

---

## Block 1 — Pull & Inspect Images

```bash
# 1
docker search nginx

# 2
docker pull nginx:1.28-alpine
# Format: <image>:[tag]-[variant]

# 3
docker images

# 4
docker pull ubuntu:24.04

# 5
docker images
```

---

## Block 2 — Run & Manage Containers

```bash
# 1
docker run -d --name webserver -p 8080:80 nginx:1.28-alpine
# -d = detached (background), --name names it, -p host:container

# 2
docker ps

# 3
docker run -it --name sandbox ubuntu:24.04 bash
# -it = interactive + pseudo-TTY. Gives you a shell inside the container.

# 4
docker ps -a
# STATUS: "Up X seconds" = running, "Exited (0)" = stopped cleanly

# 5
docker stop webserver
# Sends SIGTERM, waits 10s, then SIGKILL if still running

# 6
docker rm webserver

# 7
docker rm sandbox
```

---

## Block 3 — Throwaway Containers & Env Files

```bash
# 1
docker run --rm alpine:3.20 hostname
# --rm removes the container automatically the moment it exits

# 2
docker ps -a
# Nothing from that alpine run — it cleaned itself up

# 3
docker run --rm --env-file app.env ubuntu:24.04 env
# --env-file loads all KEY=VALUE lines into the container environment

# 4
docker run -d --name secure-web --env-file app.env nginx:1.28-alpine

# 5
docker exec secure-web env | grep DB_PASSWORD
# Password lives inside the container, never typed in your shell history

# 6
docker stop secure-web && docker rm secure-web
```

---

## Block 4 — exec, inspect, logs

```bash
# 1
docker run -d --name webserver nginx:1.28-alpine

# 2
docker exec -it webserver sh
# Use sh not bash — alpine images don't include bash
# exec = spawns a NEW process inside an EXISTING running container

# 3 (inside the container)
ps aux
ls /etc/nginx
exit
# exit only kills your sh process — nginx keeps running

# 4
docker exec webserver whoami

# 5
docker exec webserver ls /etc/nginx

# 6
docker logs --tail 20 webserver

# 7
docker inspect -f '{{.NetworkSettings.Networks.bridge.IPAddress}}' webserver
# -f uses Go template syntax to extract a specific field from the JSON

# 8
docker stop webserver && docker rm webserver
```

---

## Block 5 — Volumes & Persistent Data

```bash
# 1
docker volume create mydata

# 2
docker run --rm -v mydata:/data alpine:3.20 \
  sh -c "echo 'hello from volume' > /data/message.txt"
# -v volume_name:/container/path  mounts the named volume

# 3
docker run --rm -v mydata:/data alpine:3.20 cat /data/message.txt
# Output: hello from volume
# Container is gone but the volume (and its data) persists

# 4
cat > pg.env << 'EOF'
POSTGRES_PASSWORD=secretpass
EOF

docker run -d \
  --name mydb \
  --env-file pg.env \
  -v pg-data:/var/lib/postgresql/data \
  --restart=unless-stopped \
  postgres:16

# 5
sleep 10
docker exec mydb psql -U postgres -c "CREATE DATABASE testdb;"

# 6
docker exec mydb psql -U postgres -c "\l"
# testdb appears in the list

# 7
docker rm -f mydb
# -f = force (stop + remove in one command, no need to stop first)

# 8
docker run -d \
  --name mydb \
  --env-file pg.env \
  -v pg-data:/var/lib/postgresql/data \
  --restart=unless-stopped \
  postgres:16
sleep 5

# 9
docker exec mydb psql -U postgres -c "\l"
# testdb is still there — the volume survived container removal!

# 10
docker rm -f mydb
docker volume rm pg-data mydata
rm pg.env
```

---

## Block 6 — Build Your Own Image

```dockerfile
# greeter/Dockerfile
FROM ubuntu:24.04

WORKDIR /app

COPY greet .

RUN chmod +x greet

ENV GREETING=Hello
ENV NAME=World

CMD ["./greet"]
```

```bash
# 2
cd greeter
docker build -t greeter:1.0.0 .
# -t name:tag   . = build context (current directory)

# 3
docker run --rm greeter:1.0.0
# Output:
# ================================
#   Hello, World!
#   Running in container: <hostname>
# ================================

# 4
docker run --rm -e GREETING=Hola -e NAME=Docker greeter:1.0.0
# -e overrides the ENV values set in the Dockerfile at runtime

# 5
docker run --rm --env-file ../app.env greeter:1.0.0
# Output: Hello, World!
# Why: app.env doesn't define GREETING or NAME, so Dockerfile ENV defaults kick in.
# ENV in Dockerfile = default value. Runtime -e or --env-file overrides it only if the key is present.

# 6
docker history greeter:1.0.0
# Each row = one layer. Notice COPY and RUN near the top (most frequently changed).
# Rule: order Dockerfile from least -> most frequently changed for better cache hits.
```

---

## Block 7 — Cleanup

```bash
# 1
docker ps -a
docker container prune
# Removes all stopped containers — prompts for confirmation

# 2
docker rmi greeter:1.0.0

# 3
docker rmi nginx:1.28-alpine ubuntu:24.04

# 4
docker image prune
# Removes dangling images (untagged, not referenced by any container)

# 5
docker system df
# Shows Images / Containers / Volumes / Build Cache sizes + what's reclaimable

# 6
docker system prune -a
# -a = ALL unused images, not just dangling ones. Clean slate.
```
