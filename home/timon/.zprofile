#################################################
#		Autostart X after login on tty 1		#
#################################################
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep awesome || startx
fi
