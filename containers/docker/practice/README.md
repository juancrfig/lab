# Docker Practice

**Goal:** Muscle memory for container management — pulling, running, inspecting, cleaning, building, and securing images.

**Time:** ~30 minutes  
**Left pane:** CHALLENGES.md. **Right pane:** terminal.  
No peeking at SOLUTIONS.md until you've typed your own answer.

---

## Setup

Make sure Docker is installed and you're in the `docker` group:

```bash
sudo usermod -aG docker $USER
newgrp docker
docker --version
```

---

## Files in This Session

| File | Purpose |
|---|---|
| `CHALLENGES.md` | Exercises — do these |
| `SOLUTIONS.md` | Answers — open after |
| `app.env` | Sample env file for exercises |
| `greeter/` | Dockerfile exercise project |

---

## Quick Reference

```
docker pull <image>:[tag]          # download image
docker run <image>                 # create + start container
docker run -d --name X <image>     # background, named
docker run -it <image>             # interactive terminal
docker run --rm <image>            # throwaway container
docker run -p 8080:80 <image>      # port mapping
docker run --env-file <file>       # env vars from file
docker stop / docker rm            # stop + delete container
docker container prune             # remove all stopped containers
docker rmi <image>                 # delete image
docker image prune                 # remove unused images
docker system prune -a             # clean everything
docker ps [-a]                     # list containers
docker images                      # list images
docker search <term>               # search Docker Hub
docker exec -it <name> sh          # shell into running container
docker inspect <name>              # full container details (JSON)
docker logs <name>                 # container stdout/stderr
docker stats [--no-stream]         # CPU/memory usage
docker volume create/ls/rm/prune   # manage volumes
docker build -t <name>:<tag> .     # build image from Dockerfile
docker tag <src> <dst>             # re-tag an image
docker push <image>                # push to registry
```
