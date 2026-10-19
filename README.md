# arch-linux-setup

My personal Arch Linux setup: Sway, Tokyo Night, one command from a bare
`archinstall` to a configured system. Built for my own machines and taste,
not as a general-purpose distribution.

```bash
curl -fsSL https://raw.githubusercontent.com/MarioFronza/arch-linux-setup/main/boot.sh | bash
```

Starting from blank hardware? See [`QUICKSTART.md`](QUICKSTART.md): install
media through a working, SSH-reachable base system, then the command above.

## How it works

`boot.sh` installs git, clones this repo to `~/.local/share/arch-linux-setup` and
sources `install.sh`, which runs every `modules/*/install.sh` in order.

Each module is one self-contained directory: the script plus exactly the
files it copies. Adding or removing a module is adding or removing a
directory. They are numbered in dependency order, in steps of 5.

| Module | What it does |
|---|---|
| `05-packages` | pacman + AUR, GPU driver auto-detected via `lspci` |
| `10-udev` | USB wake-on-connect, battery charge thresholds |
| `15-dotfiles` | clones [dotfiles](https://github.com/MarioFronza/dotfiles) to `~/dotfiles` and stows every package into `$HOME` |
| `20-zsh` | sets zsh as the login shell |
| `25-tmux` | clones tpm |
| `30-git` | seeds `~/.config/git/identity` from the dotfiles template |
| `35-pipx` | installs frida-tools from PyPI |
| `40-mise` | installs language/tool versions |
| `45-boot` | Plymouth password screen, silent boot, autologin on tty1 when the disk is encrypted (the disk password is then the only prompt) |
| `50-default-apps` | Firefox as default browser, Alacritty as default terminal |

Every file under `$HOME` comes from dotfiles as a symlink, so editing a
config on the machine edits the clone. Commit and push from `~/dotfiles`.
Claude Code's `settings.json` and btop's `btop.conf` are the exceptions:
they are copied once, because their apps rewrite them at runtime.

## After installing

What is left is interactive or account-bound, so `install.sh` stops short of
it. Do it in this order, after the reboot.

### 1. Network, bluetooth and the tailscale daemon

These take the network down, so run them from the machine's own console,
not over SSH:

```bash
bash ~/.local/share/arch-linux-setup/modules/05-packages/enable-services.sh
impala    # join a wifi network (bluetui for bluetooth)
```

### 2. Git identity

Fill in your name and email in `~/.config/git/identity`. `signingkey` already
points at the SSH key generated next.

### 3. SSH key

```bash
ssh-keygen -t ed25519 -C "you@example.com" -f ~/.ssh/id_ed25519
```

### 4. GitHub CLI and the key on GitHub

Log in, picking `GitHub.com`, `SSH` as the protocol, skipping the key upload
it offers, and authenticating in the browser:

```bash
gh auth login
gh auth refresh -h github.com -s admin:public_key,admin:ssh_signing_key
```

Add the key twice, once to push and once to sign commits:

```bash
gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title "$(hostname)"
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "$(hostname)"
```

Let git verify your own signatures locally, and switch the dotfiles clone to
SSH so you can push from it:

```bash
printf '%s namespaces="git" %s\n' \
  "$(git config user.email)" "$(cut -d' ' -f1,2 ~/.ssh/id_ed25519.pub)" \
  > ~/.config/git/allowed_signers
git -C ~/dotfiles remote set-url origin git@github.com:MarioFronza/dotfiles.git
```

Check it:

```bash
ssh -T git@github.com              # "Hi <user>! You've successfully authenticated"
git -C ~/dotfiles log --show-signature -1
```

### 5. Tailscale

```bash
sudo tailscale up                       # prints a URL, open it to add the machine
sudo tailscale set --operator="$USER"   # run tailscale without sudo from now on
tailscale status
```

Disk partitioning, encryption and the bootloader stay with `archinstall`,
see [`QUICKSTART.md`](QUICKSTART.md).

If the install fails, fix the cause and re-run it. It is safe to run twice:

```bash
bash ~/.local/share/arch-linux-setup/install.sh
```
