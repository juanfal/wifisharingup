#!/bin/sh
# juanfal 2018-05-07
# script to check if the wifi service is active, and then has an IP
# and, if not, resets it login this very action

if [[ ! `ipconfig getifaddr en1` ]]; then
    /usr/sbin/networksetup -setairportpower en1 off
    /usr/sbin/networksetup -setairportpower en1 on
    echo `date` >> "/Users/me/Library/Logs/wifisharingup.err"
else
    touch "/Users/me/Library/Logs/wifisharingup.out"
fi
