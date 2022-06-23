#!/bin/sh

#########################
#		Functions		#
#########################
run() {
	cmd="$1"
	program=$(echo "$1" | awk '{print $1}')
	if ! pgrep -f $program; then
		$cmd &
	fi
}



#################################
#		Background programs		#
#################################
run "picom --daemon"
run "pcmanfm --daemon-mode"
run "clipmenud"



#################################
#		Tray applications		#
#################################
run "flameshot"
sleep 1
run "nm-applet"
sleep 1
run "redshift-gtk"
sleep 1
run "volctl"
