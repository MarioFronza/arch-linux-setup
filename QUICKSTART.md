# Quickstart: fresh machine to configured

## 1. Boot the install media

Download the [Arch Linux ISO](https://archlinux.org/download/), write it
to a USB drive, boot from it with Secure Boot disabled.

## 2. Get on the network

Wired: nothing to do, DHCP just works.

Wifi:

```bash
iwctl
station wlan0 scan
station wlan0 connect <SSID>   # tab-complete after "connect "
```

## 3. Run archinstall

```bash
archinstall
```

| Section | Setting |
|---|---|
| Mirrors and repositories | Select regions > your country |
| Disk configuration | Partitioning > select disk > Use a best-effort default partition layout |
| Disk > File system | btrfs (default subvolumes, use compression) |
| Disk > Disk encryption | Encryption type: LUKS > set password > Partitions: select which one to encrypt (recommended, not required) |
| Bootloader | Limine |
| Hostname | whatever you want |
| Authentication > Root password | set one |
| Authentication > User account | add yourself, Superuser: yes |
| Profile | leave empty |
| Applications > Audio | no audio server |
| Network configuration | copy ISO network config |
| Timezone | yours |

Leave the profile and audio sections alone on purpose. Every desktop
profile drags in a compositor, a launcher and a terminal of its own
choosing, and arch-linux-setup installs its own set (see
[`modules/05-packages/pacman.txt`](modules/05-packages/pacman.txt)). Picking
one only means uninstalling the parts you don't want afterwards.

Reboot, log in as the user you created.

## 4. Enable SSH, finish setup from another machine

Doing the rest over SSH from a real terminal beats fighting the console
font forever.

On the new machine:

```bash
sudo pacman -S --needed openssh
sudo systemctl enable --now sshd
ip a   # note the IP
```

From another machine:

```bash
ssh <user>@<ip>
```

## 5. Run arch-linux-setup

One command, everything the machine needs (multilib, pacman + AUR
packages, GPU driver, every module's config):

```bash
curl -fsSL https://raw.githubusercontent.com/MarioFronza/arch-linux-setup/main/boot.sh | bash
```

See [`README.md`](README.md) for what this installs and what it
deliberately leaves manual.

## 6. Finish by hand

Follow [After installing](README.md#after-installing) in the README:
network services, git identity, SSH key, GitHub CLI and tailscale.
