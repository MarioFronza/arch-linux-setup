cd "$(dirname "${BASH_SOURCE[0]}")"

if compgen -G "/sys/class/power_supply/BAT*" >/dev/null; then
  echo "==> Keeping the default power profile (battery detected)"
else
  echo "==> Setting the performance power profile (no battery)"
  sudo powerprofilesctl set performance
fi
