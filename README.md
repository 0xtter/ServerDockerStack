<p align="center">
  <img src="docs/images/Logo.png" />
</p>

---

## 🚀 Deploy

Create the `.env` file:

```bash
cp example.env .env
```

And adjust the values according to your needs.

---

Use the included helper script to start/stop stacks in the correct order:

```bash
# Make the script executable (Linux/macOS/WSL/Git Bash)
chmod +x ServerDockerStack.sh

# Bring all stacks up (network started first):
./ServerDockerStack.sh up example.env .

# Bring all stacks down (network stopped last):
./ServerDockerStack.sh down example.env .
```

> [!NOTE] 
> The script is a Bash script—on Windows run it from WSL or Git Bash (for example: `wsl ./ServerDockerStack.sh up example.env .`).


Other option is to manually run start the stacks (**network first and required**):

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

## ⚙️ Service Unit File

After a machine reboot, docker can restart the stack in the wrong order, in order to fix this issue, you can manually create a service to manage the stacks:

Create a new systemd unit file at:

```bash
sudo nano /etc/systemd/system/serverdockerstack.service
```

Then paste the following:

```toml
[Unit]
Description=Server Docker Stack Manager
After=network.target docker.service
Requires=docker.service

[Service]
Type=oneshot
WorkingDirectory=</path/to/ServerDockerStack>
Environment=GENERAL_BASE_DOCKER_STATIC_CONFIG_PATH=</path/to/ServerDockerStack/static_config>
ExecStart=/bin/bash </path/to/ServerDockerStack/>ServerDockerStack.sh up </path/to/secrets/ServerDockerStackEnv> </path/to/ServerDockerStack>
ExecStop=/bin/bash </path/to/ServerDockerStack/>ServerDockerStack.sh down </path/to/secrets/ServerDockerStackEnv> </path/to/ServerDockerStack>
RemainAfterExit=true
User=<replace_with_the_user>
Group=nobody

[Install]
WantedBy=multi-user.target
```

## 🔧 Notes

- Replace **</path/to/ServerDockerStack>** with the actual directory path where your project lives.
- Replace **</path/to/secrets/ServerDockerStackEnv>** with the actual path to your environment file.
- Ensure to set the correct user to run the stack : **<replace_with_the_user>**
- The group **nobody** is used here, but you can change it to a more appropriate group if needed.

## 🚀 Usage

Enable the service so it starts automatically at boot:

```bash
sudo systemctl enable serverdockerstack
```

Start the service

```bash
sudo systemctl start serverdockerstack
```

Stop the service

```bash
sudo systemctl stop serverdockerstack
```

Check the status

```bash
systemctl status serverdockerstack
```