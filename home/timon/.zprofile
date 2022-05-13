#################################################
#		Autostart X after login on tty 1		#
#################################################
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
