cd "$(dirname "${BASH_SOURCE[0]}")"

# Only D-Bus activation would start it otherwise, and waybar, which starts
# first, hides its power profile icon for good when the daemon is missing.
echo "==> Enabling power-profiles-daemon"
sudo systemctl enable --now power-profiles-daemon

if compgen -G "/sys/class/power_supply/BAT*" >/dev/null; then
  echo "==> Keeping the default power profile (battery detected)"
elif powerprofilesctl list | grep -q 'performance:'; then
  echo "==> Setting the performance power profile (no battery)"
  sudo powerprofilesctl set performance
else
  echo "==> Skipping the performance power profile (no driver offers it)"
fi
