function _set_vars() {
  typeset -gx DUNST_CACHE_DIR="$HOME/.cache/dunst"
  typeset -gx DUNST_LOG="$DUNST_CACHE_DIR/notifications.txt"
}

function _unset_vars() {
  unset DUNST_CACHE_DIR
  unset DUNST_LOG
}