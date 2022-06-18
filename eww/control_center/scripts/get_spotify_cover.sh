
#!/usr/bin/bash

tmp_dir="/tmp/taritha/spotify"
tmp_cover_path=$tmp_dir/cover.png

if [ ! -d $tmp_dir ]; then
	mkdir -p $tmp_dir
fi

while sleep 0.5; do
	artlink="$(playerctl metadata -p spotify mpris:artUrl | sed -e 's/open.spotify.com/i.scdn.co/g')"

	if [ $(playerctl metadata -p spotify mpris:artUrl) ]; then
		curl -s "$artlink" --output $tmp_cover_path;
		echo "$tmp_cover_path"
	else 
		cp ~/.config/eww/control_center/images/music.svg $tmp_cover_path;
		echo "$tmp_cover_path"
	fi
done