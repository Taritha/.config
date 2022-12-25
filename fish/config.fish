if status is-interactive
    # Commands to run in interactive sessions can go here
end
cat ~/.config/wpg/sequences &

export PATH="$PATH:$HOME/.local/bin/"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
fish_add_path /home/taritha/.spicetify
