cd "$(dirname "${BASH_SOURCE[0]}")"

if compgen -G "/sys/class/power_supply/BAT*" >/dev/null; then
  echo "==> Keeping the default power profile (battery detected)"
elif PATH="/usr/bin:$PATH" powerprofilesctl list | grep -q 'performance:'; then
  echo "==> Setting the performance power profile (no battery)"
  sudo powerprofilesctl set performance
else
  echo "==> Skipping the performance power profile (no driver offers it)"
fi
