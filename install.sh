# Exit immediately if a command exits with a non-zero status
set -e

# Give people a chance to retry running the installation
trap 'echo "arch-linux-setup installation failed! You can retry by running: bash ~/.local/share/arch-linux-setup/install.sh"' ERR

# The run spans 30-90 minutes because mise builds several toolchains from
# source, so the initial sudo timestamp expires long before the end. Refresh it
# in the background, and stop when this shell does.
sudo -v
while true; do sudo -n true; sleep 50; done 2>/dev/null &
sudo_keepalive=$!
trap 'kill "$sudo_keepalive" 2>/dev/null' EXIT

if [[ ! -f ~/.config/git/identity && -z "${GIT_NAME:-}${GIT_EMAIL:-}" ]]; then
  read -rp "Git name: " GIT_NAME </dev/tty
  read -rp "Git email: " GIT_EMAIL </dev/tty
fi

# Every module is self-contained: modules/NN-name/install.sh plus the files
# it copies. Numbered in dependency order, in steps of 5 to leave room.
for f in ~/.local/share/arch-linux-setup/modules/*/install.sh; do source "$f"; done

sudo updatedb

echo
echo "==> arch-linux-setup install done. Finish the manual steps in \"After installing\":"
echo "    ~/.local/share/arch-linux-setup/README.md"
echo

gum confirm "Reboot to apply all settings?" && sudo reboot
