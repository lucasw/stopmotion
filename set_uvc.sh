#!/bin/sh


# use this uvc ctrl app instead:
# v4lucp

uvcdynctrl --device=/dev/video0 -c
uvcdynctrl --device=/dev/video0 --set 'White Balance Temperature, Auto' Off

# assumes /dev/video1 is webcam, and has all these control
# (this is a logitech c910)
# list controls
uvcdynctrl --device=/dev/video1 -c
# 3 is automatic and 1 is off
uvcdynctrl --device=/dev/video1 --set='Exposure, Auto' 1
uvcdynctrl --device=/dev/video1 --set='White Balance Temperature, Auto' Off
# yellow and saturated
#uvcdynctrl --device=/dev/video1 --set='White Balance Temperature' 7000
uvcdynctrl --device=/dev/video1 --set='White Balance Temperature' 3500
uvcdynctrl --device=/dev/video1 --set='Focus, Auto' Off
uvcdynctrl --device=/dev/video1 --set='Exposure, Auto Priority' Off
uvcdynctrl --device=/dev/video1 --set='Focus (absolute)' 100

uvcdynctrl --device=/dev/video1 --get='Exposure, Auto' 
uvcdynctrl --device=/dev/video1 --get='White Balance Temperature, Auto' 
uvcdynctrl --device=/dev/video1 --get='Focus, Auto' 
uvcdynctrl --device=/dev/video1 --get='Exposure, Auto Priority' 

# 
uvcdynctrl --device=/dev/video1 --get='Exposure (Absolute)'

# near focus
#uvcdynctrl --device=/dev/video1 --set='Focus (absolute)' 170
# far focus
#uvcdynctrl --device=/dev/video1 --set='Focus (absolute)' 50



