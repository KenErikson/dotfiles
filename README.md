
# Dotfiles

My dotfiles, will add more soon™


## Clone

```
git clone --bare git@github.com:USERNAME/dotfiles.git $HOME/.dotfiles

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

dotfiles config --local status.showUntrackedFiles no

mkdir -p .dotfiles-backup
dotfiles checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | \
  xargs -I{} mv {} .dotfiles-backup/{}

dotfiles checkout

```
