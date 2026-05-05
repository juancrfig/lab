# Docker Practice Challenges

Left pane: this file. Right pane: terminal.
No peeking at SOLUTIONS.md until you've run your own answer.

---

## Block 1 — Pull & Inspect Images

1. Search Docker Hub for the official `nginx` image.
2. Pull `nginx` with tag `1.28` and variant `alpine`.
3. List all locally stored images.
4. Pull an `ubuntu` image with tag `24.04`
5. List images again — confirm both are there.

---

## Block 2 — Run & Manage Containers

1. Run an `nginx` image, tag 1.28, variant *alpine*,  container named `webserver`,q in the background, mapping host port `8080` to container port `80`.
2. Confirm it's running.
3. Run an `ubuntu:24.04` container named `sandbox` interactively with a bash shell. Type `exit` to leave.
4. List **all** containers (running + stopped) and note their STATUS column.
5. Stop `webserver`.
6. Remove `webserver`.
7. Remove `sandbox`.

---

## Block 3 — Throwaway Containers & Env Files

1. Run a throwaway `alpine:3.20` container that prints `hostname` and self-destructs.
2. Confirm it left no container behind.
3. Run `ubuntu:24.04` with the `app.env` file loaded, print all env vars, then auto-remove.
4. Run `nginx:1.28-alpine` named `secure-web` in the background using loading the file with secrets `app.env`.
5. Confirm `DB_PASSWORD` is set inside `secure-web` — without it ever appearing in your shell history.
6. Stop and remove `secure-web`.

---

## Block 4 — exec, inspect, logs

1. Start `nginx:1.28-alpine` named `webserver` in the background.
2. Open a shell **inside the running** `webserver` container.
3. Inside the container: run `ps aux` and `ls /etc/nginx`. Then exit.
4. From the host, run a **single command** inside `webserver` to check what user it's running as.
5. From the host, run a **single command** to list files in `/etc/nginx` inside `webserver`.
6. View the last 20 log lines of `webserver`.
7. Get just the IP address of `webserver`
8. Stop and remove `webserver`.

---

## Block 5 — Volumes & Persistent Data

1. Create a named volume called `mydata`.
2. Run a throwaway `alpine:3.20` container, mount `mydata` to `/data`, write `"hello from volume"` to `/data/message.txt`.
3. Run another throwaway alpine to read `/data/message.txt` — confirm the data survived.
4. Create a `pg.env` file with `POSTGRES_PASSWORD=secretpass` inside it. Then run `postgres:16` detached and named `mydb` with:
   - Env vars loaded from `pg.env`
   - Volume `pg-data` mounted to `/var/lib/postgresql/data`
   - Restart policy: `unless-stopped`
5. Wait 10 seconds, then create a database: `docker exec mydb psql -U postgres -c "CREATE DATABASE testdb;"`
6. Verify it exists: `docker exec mydb psql -U postgres -c "\l"`
7. Force-remove `mydb` (keep the volume).
8. Recreate `mydb` with the exact same command. Wait 5 seconds.
9. Verify `testdb` still exists.
10. Clean up: remove the container, both volumes, and `pg.env`.

---

## Block 6 — Build Your Own Image

Work inside `greeter/`.

1. Fill in `greeter/Dockerfile` so it:
   - Uses `ubuntu:24.04` as base
   - Sets `WORKDIR /app`
   - Copies `greet`
   - Runs `chmod +x greet`
   - Sets `ENV GREETING=Hello` and `ENV NAME=World`
   - Has `CMD ["./greet"]`
2. Build it as `greeter:1.0.0`.
3. Run it with defaults — you should see `Hello, World!`
4. Run it overriding `-e GREETING=Hola -e NAME=Docker`.
5. Run it with `--env-file ../app.env` — what does it print for GREETING? Why?
6. Check the image layers with `docker history greeter:1.0.0`.

---

## Block 7 — Cleanup

1. List all containers (any state). Remove all stopped ones in one command.
2. Remove `greeter:1.0.0`.
3. Remove any remaining unused/dangling images.
4. Check disk usage.
5. Run a full system prune that removes ALL unused images (not just dangling).
