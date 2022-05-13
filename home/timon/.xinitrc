#####################################
#		Source xinit scripts		#
#####################################
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi



#####################################
#		Import environments		#
#####################################
systemctl --user import-environment DISPLAY



#############################################
#		Start background applications		#
#############################################
picom --daemon --experimental-backends &
nm-applet &
pnmixer &
thunar --daemon &
flameshot &



#############################
#		Setup screens		#
#############################
/usr/local/bin/setupScreen.sh &



#####################################
#		Start window manager		#
#####################################
exec awesome
