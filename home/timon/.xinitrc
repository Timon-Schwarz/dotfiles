#####################################
#		Source xinit scripts		#
#####################################
for f in /etc/X11/xinit/xinitrc.d/*.sh; do
  source "$f"
done



#############################
#		Keyboard layout		#
#############################
setxkbmap at -variant nodeadkeys



#############################################
#		Start background applications		#
#############################################
picom --daemon --experimental-backends &
nm-applet &
pnmixer &
thunar --daemon &



#####################################
#		Start window manager		#
#####################################
exec awesome
