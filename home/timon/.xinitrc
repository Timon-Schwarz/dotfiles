#########################
#		Variables		#
#########################
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap



#########################################
#		Resource and map merging		#
#########################################
[[ -f $sysresources ]] && xrdb -merge $sysresources
[[ -f $sysmodmap ]] && xmodmap $sysmodmap
[[ -f "$userresources" ]] && xrdb -merge "$userresources"
[[ -f "$usermodmap" ]] && xmodmap "$usermodmap"



#####################################
#		Source xinit scripts		#
#####################################
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi



#############################################
#		Start background applications		#
#############################################
picom --daemon &
nm-applet &
volumeicon &
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
