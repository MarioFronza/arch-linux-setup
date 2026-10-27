cd "$(dirname "${BASH_SOURCE[0]}")"

echo "==> Enabling docker"
sudo systemctl enable --now docker.service

echo "==> Adding $USER to the docker group"
sudo usermod -aG docker "$USER"
