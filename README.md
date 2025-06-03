# Server Docker Stack

Create the `.env` file:

```bash
cp example.env .env
```

And adjust the values according to your needs.

After, run:

```bash
docker compose -f network/docker-compose.yaml --env-file .env up -d
```

And then, chose the compose you also want to run:

```bash
docker compose -f other/docker-compose.yaml --env-file .env up -d
docker compose -f monitoring/docker-compose.yaml --env-file .env up -d
docker compose -f media/docker-compose.yaml --env-file .env up -d
```

Or run it all! :

```bash
find . -name "docker-compose.yaml" -exec docker compose -f {} --env-file .env up -d \;
```

---

To update a compose, run :

```bash
docker compose -f other/docker-compose.yaml --env-file .env down
# Here modify compose
docker compose -f other/docker-compose.yaml --env-file .env up -d
```