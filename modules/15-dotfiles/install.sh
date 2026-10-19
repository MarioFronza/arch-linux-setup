cd "$(dirname "${BASH_SOURCE[0]}")"

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/MarioFronza/dotfiles.git}"

echo "==> Cloning dotfiles"
[[ -d ~/dotfiles ]] || git clone "$DOTFILES_REPO" ~/dotfiles

echo "==> Stowing dotfiles"
mapfile -t packages < <(find ~/dotfiles -maxdepth 1 -mindepth 1 -type d ! -name '.*' ! -name 'test' -printf '%f\n')
stow --no-folding -d ~/dotfiles -t ~ "${packages[@]}" || {
  echo "==> Files listed above are in the way. See \"Migrating a configured machine\" in ~/.local/share/arch-linux-setup/README.md" >&2
  false
}

echo "==> Copying configs that their apps rewrite at runtime"
[[ -e ~/.claude/settings.json ]] || cp ~/dotfiles/claude/.claude/settings.json ~/.claude/settings.json
[[ -e ~/.config/btop/btop.conf ]] || cp ~/dotfiles/btop/.config/btop/btop.conf ~/.config/btop/btop.conf
