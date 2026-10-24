cd "$(dirname "${BASH_SOURCE[0]}")"

if [[ ! -f ~/.config/git/identity ]]; then
  echo "==> Seeding git identity"
  cp ~/dotfiles/git/.config/git/identity.example ~/.config/git/identity
  git config -f ~/.config/git/identity user.name "$GIT_NAME"
  git config -f ~/.config/git/identity user.email "$GIT_EMAIL"
fi
