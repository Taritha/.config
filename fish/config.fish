if status is-interactive
    # Commands to run in interactive sessions can go here
end
cat ~/.config/wpg/sequences &
export login=false

# Startup applications
if status is-login; and not login
	autorandr default &
	sleep 0.5
	thunar --daemon &
	#discord --start-minimized &
	lxsession &
	greenclip daemon &
	xset s off &
	xset -dpms &
	wpg -m &
	/usr/lib/pentablet/pentablet.sh &
	eww --config ~/.config/eww/control_center/ daemon &
	eww --config ~/.config/eww/indicators/ daemon &
	eww --config ~/.config/eww/info_center/ open info-center &
	eww --config ~/.config/eww/bars/ open topbar &
	eww --config ~/.config/eww/bars/ open audio &
	eww --config ~/.config/eww/bars/ open netbar &
	eww --config ~/.config/eww/bars/ open botbar &
	export login=true &
end

export PATH="$PATH:$HOME/.local/bin/"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
fish_add_path /home/taritha/.spicetify
