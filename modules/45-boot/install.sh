cd "$(dirname "${BASH_SOURCE[0]}")"

# The disk password is the only prompt: Plymouth asks for it on a plain Tokyo
# Night screen, tty1 then logs in on its own and .zprofile starts sway.

echo "==> Installing the Plymouth theme"
sudo mkdir -p /usr/share/plymouth/themes/tokyo-night
sudo cp theme/* /usr/share/plymouth/themes/tokyo-night/
sudo plymouth-set-default-theme tokyo-night

echo "==> Adding plymouth to the initramfs"
# Right after base udev/systemd, so it is up before the encrypt hook prompts.
if ! grep -qE '^HOOKS=\(.*\bplymouth\b' /etc/mkinitcpio.conf; then
  sudo sed -i -E 's/^(HOOKS=\(base (udev|systemd))/\1 plymouth/' /etc/mkinitcpio.conf
fi

echo "==> Silencing the boot"
quiet_flags="quiet splash loglevel=3 rd.udev.log_level=3 systemd.show_status=false rd.systemd.show_status=false vt.global_cursor_default=0"
# limine-entry-tool reads KERNEL_CMDLINE from /etc/default/limine when set
# there, and falls back to /etc/kernel/cmdline otherwise. A bare `+=` with no
# base cmdline would drop root= and cryptdevice=, so extend whichever is in use.
if grep -q '^KERNEL_CMDLINE' /etc/default/limine 2>/dev/null; then
  grep -qw splash /etc/default/limine ||
    echo "KERNEL_CMDLINE[default]+=\" $quiet_flags\"" | sudo tee -a /etc/default/limine >/dev/null
else
  [[ -s /etc/kernel/cmdline ]] ||
    sed 's/BOOT_IMAGE=[^ ]* //' /proc/cmdline | sudo tee /etc/kernel/cmdline >/dev/null
  grep -qw splash /etc/kernel/cmdline ||
    sudo sed -i "s/\$/ $quiet_flags/" /etc/kernel/cmdline
fi

echo "==> Enabling autologin on tty1"
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sed "s/USER/$USER/" autologin.conf | sudo tee /etc/systemd/system/getty@tty1.service.d/autologin.conf >/dev/null

echo "==> Rebuilding initramfs and boot entries"
sudo limine-update
