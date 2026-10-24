cd "$(dirname "${BASH_SOURCE[0]}")"

# Unlike the services in enable-services.sh, docker leaves existing
# interfaces alone, so it is safe to start over ssh.
echo "==> Enabling docker"
sudo systemctl enable --now docker.service

# The docker group is root-equivalent; it takes effect on the next login.
echo "==> Adding $USER to the docker group"
sudo usermod -aG docker "$USER"
