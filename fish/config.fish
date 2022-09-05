\if status is-interactive
    # Commands to run in interactive sessions can go here
end
cat ~/.config/wpg/sequences &
#export login=false

# Startup applications
if status is-login
	autorandr default &
	sleep 0.5
	thunar --daemon &
	#discord --start-minimized &
	lxsession &
	greenclip daemon &
	wpg -m &
	#/usr/lib/pentablet/pentablet.sh &
	rfkill block bluetooth && sleep 0.2 &
	rfkill unblock bluetooth &
end

export PATH="$PATH:$HOME/.local/bin/"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
fish_add_path /home/taritha/.spicetify
