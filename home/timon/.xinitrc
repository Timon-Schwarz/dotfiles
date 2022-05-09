#################################
# Start background applications #
#################################
picom --daemon --experimental-backends &
nm-applet &
thunar --daemon &



########################
# Start window manager #
########################
exec awesome
