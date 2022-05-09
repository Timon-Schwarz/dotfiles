#################################
# Start background applications #
#################################
picom --daemon --experimental-backends &
thunar --daemon &



########################
# Start window manager #
########################
exec awesome
