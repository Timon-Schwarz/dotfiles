#####################################
#		Source xinit scripts		#
#####################################
for f in /etc/X11/xinit/xinitrc.d/*.sh; do
  source "$f"
done



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
