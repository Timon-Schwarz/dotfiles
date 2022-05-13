#####################################
#		Source xinit scripts		#
#####################################
for f in /etc/X11/xinit/xinitrc.d/*.sh; do
  source "$f"
done



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



#############################
#		Setup screens		#
#############################
/usr/local/bin/setupScreen.sh &



#####################################
#		Start window manager		#
#####################################
exec awesome
