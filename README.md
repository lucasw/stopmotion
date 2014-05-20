stopmotion
==========

stopmotion with Processing (processing.org)


ffmpeg to make videos
---------------------

Get ffmpeg (avconv may also work)::
  git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg

command line::
  ffmpeg -r 9 -i cur_1400550344228_10%03d.jpg -b:v 5000k -strict -2 animation.mp4
  
Add music (Kevin MacLeod from incompetech.com)::
  ffmpeg -r 9 -i cur_1400550344228_10%03d.jpg -i ~/Downloads/kevin_macleod/8bit\ Dungeon\ Boss.mp3 -b:v 5000k -strict -2 -shortest kings_castle_6080_music.mp4

