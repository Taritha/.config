#!/usr/bin/env zsh
source "$HOME/.config/eww/control_center/scripts/config.zsh"
_set_vars

mkdir "$DUNST_CACHE_DIR" 2>/dev/null
touch "$DUNST_LOG" 2>/dev/null

function create_cache() {
  local urgency
  case "$DUNST_URGENCY" in
    "LOW"|"NORMAL"|"CRITICAL") urgency="$DUNST_URGENCY";;
    *) urgency="OTHER";;
  esac

  local summary
  local body
  [ "$DUNST_SUMMARY" = "" ] && summary="Summary unavailable." || summary="$DUNST_SUMMARY"
  [ "$DUNST_BODY" = "" ] && body="Body unavailable." || body="$(print "$DUNST_BODY" | recode html)"

  local glyph
  case "$urgency" in
    "LOW") glyph="";;
    "NORMAL") glyph="";;
    "CRITICAL") glyph="";;
    *) glyph="";;
  esac
  case "$DUNST_APP_NAME" in
    "Spotify") glyph="阮";;
    "Slack") glyph="聆";;
    "Discord") glyph="ﭮ";;
    "evolution-mail-notification") glyph="﯍";;
    "evolution-alarm-notify") glyph="";;
    "Package Manager") glyph="";;
    "thunar-volman") glyph="淋";;
    "firefox") glyph="";;
  esac
  # pipe stdout -> pipe cat stdin (cat conCATs multiple files and sends to stdout) -> absorb stdout from cat
  # concat: "one" + "two" + "three" -> notice how the order matters i.e. "one" will be prepended
  print '(card :class "control-center-card control-center-card-'$urgency' control-center-card-'$DUNST_APP_NAME'" :glyph_class "control-center-'$urgency' control-center-'$DUNST_APP_NAME'" :SL "'$DUNST_ID'" :L "dunstctl history-pop '$DUNST_ID'" :body "'$body'" :summary "'$summary'" :glyph "'$glyph'" :d_body "'$DUNST_BODY'")' \
    | cat - "$DUNST_LOG" \
    | sponge "$DUNST_LOG"
}

function compile_caches() { tr '\n' ' ' < "$DUNST_LOG" }
 
function make_literal() {
  local caches="$(compile_caches)"
  # local quote="$($HOME/.config/eww/Control-Center/scripts/quotes.zsh rand)"
  local quote=" All caught up!"
  [[ "$caches" == "" ]] \
    && print '(box :class "control-center-empty-box" :height 600 :vexpand true :orientation "vertical" :space-evenly false (image :class "control-center-empty-banner" :valign "end" :vexpand true :path "" :image-width 200 :image-height 200) (label :vexpand true :valign "start" :wrap true :class "control-center-empty-label" :text "'$quote'"))' \
    || print "(scroll :height 600 :vexpand true :vscroll true (box :orientation 'vertical' :class 'control-center-scroll-box' :spacing 15 :space-evenly false $caches))"
}

function clear_logs() {
  killall dunst 2>/dev/null
  dunst & disown
  print > "$DUNST_LOG"
}

function pop() { sed -i '1d' "$DUNST_LOG" }

function drop() { sed -i '$d' "$DUNST_LOG" }

function remove_line() { sed -i '/SL "'$1'"/d' "$DUNST_LOG" }

function critical_count() { 
  local crits=$(cat $DUNST_LOG | grep CRITICAL | wc -l)
  local total=$(cat $DUNST_LOG | wc -l)
  print $(((crits*100)/total))
}

function subscribe() {
  make_literal
  local lines=$(cat $DUNST_LOG | wc -l)
  while sleep 0.5; do
    local new=$(cat $DUNST_LOG | wc -l)
    [[ $lines -ne $new ]] && lines=$new && print
  done | while read -r _ do; make_literal done
}

case "$1" in
  "pop") pop;;
  "drop") drop;;
  "clear") clear_logs;;
  "subscribe") subscribe;;
  "rm_id") remove_line $2;;
  "crits") critical_count;;
  *) create_cache;;
esac

sed -i '/^$/d' "$DUNST_LOG"
_unset_vars

# vim:ft=zsh