#################################
# Start background applications #
#################################
picom --daemon &
thunar --daemon &



########################
# Start window manager #
########################
exec awesome
