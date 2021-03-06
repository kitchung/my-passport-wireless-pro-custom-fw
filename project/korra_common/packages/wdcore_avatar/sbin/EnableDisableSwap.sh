#!/bin/sh
# Enable or Disable Swap
#

RETVAL=0

enable() {
    #echo "Start Swap"

    ACMode=`cat /tmp/battery | cut -d " " -f 1`
    if [ "${ACMode}" == "discharging" ] && [ "`/usr/local/sbin/getServiceStartup.sh plexmediaserver`" == "disabled" ]; then
        echo "Battery Discharging!!! and Plex enabled"
        MountDevNode=`cat /tmp/MountedDevNode`
        fstype=`blkid ${MountDevNode} | sed -n 's/.* TYPE="\([^"]*\)".*/\1/p'`
        if [ "${ACMode}" == "discharging" ] && [ "${fstype}" != "hfsplus" ]; then
            echo "Battery Discharging!!! and with hfsplus"
            exit 0	  
        fi
    fi
    swap_paratition=`cat /proc/partitions | grep sdc2 | wc -l`
    if [ "${swap_paratition}" == "1" ]; then
        /sbin/swapon /dev/sdc2
	ret=$?
	if [ "${ret}" == "255" ]; then
	    /sbin/mkswap /dev/sdc2
	    /sbin/swapon /dev/sdc2
	fi
    else
        if [ -f /swapfile ]; then
            /sbin/swapon /swapfile
        else
            /sbin/CreateSwapfile.sh &
        fi
    fi

}	

disable() {
    MountDevNode=`cat /tmp/MountedDevNode`
    fstype=`blkid ${MountDevNode} | sed -n 's/.* TYPE="\([^"]*\)".*/\1/p'`
    if [ "`/usr/local/sbin/getServiceStartup.sh plexmediaserver`" == "disabled" ] && [ "${fstype}" != "hfsplus" ]; then
        /sbin/swapoff -a
    fi

}	

restart() {
	disable
	enable
}	

case "$1" in
  enable)
  	enable
	;;
  disable)
  	disable
	;;
  restart)
  	restart
	;;
  *)
	echo "Usage: $0 {enable|disable|restart}"
	exit 1
esac

exit $?
