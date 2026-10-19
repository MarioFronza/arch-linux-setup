cd "$(dirname "${BASH_SOURCE[0]}")"

echo "==> Installing frida-tools"
pipx install --python /usr/bin/python frida-tools
