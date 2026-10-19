cd "$(dirname "${BASH_SOURCE[0]}")"

echo "==> Setting Firefox and Alacritty as default apps"
sudo cp mimeapps.list xdg-terminals.list /etc/xdg/
