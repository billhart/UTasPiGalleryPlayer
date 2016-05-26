#UTAS (Tasmanian College of the Arts) Gallery Media Player
Bill Hart 2016

What it does - it takes a raspberry pi and turns it into a simple box that plays audio and video. Recommended for a Raspberry Pi 2 or better.
To use stick in a USB stick with one or more fies, plug the pi in or turn it on and it plays the files in a loop until its turned off.
No remotes, no menus, no configuration.  

Features - supports USB FAT32, NTFS, HFS+ media - the built in VIDEOS partition (exFat) or a NTFS/HFS+ USB will play files greater than 4 GB  (USB ExFAT drives have some problems)

Video - up to 30 fps 1080p (Raspberry Pi 3 will do 4K and 60 fps 1080p)

Audio - output both through HDMI and audio jack

Should play anything FFMPEG will play.

Loop has several frames of black inbetween playback.
Can use keyboard commands to stop or synchronise playback (manually) across several players.
>1           decrease speed

>2           increase speed

>\<           rewind

>\>           fast forward

>z           show info

>j           previous audio stream

>k           next audio stream

>i           previous chapter

>o           next chapter

>n           previous subtitle stream

>m           next subtitle stream

>s           toggle subtitles

>w           show subtitles

>x           hide subtitles

>d           decrease subtitle delay (- 250 ms)

>f           increase subtitle delay (+ 250 ms)

>q           exit omxplayer

>p / space   pause/resume

>\-           decrease volume

>\+ / =       increase volume

>left arrow  seek -30 seconds

>right arrow seek +30 seconds

>down arrow  seek -600 seconds

>up arrow    seek +600 seconds


A 16GB formatted disk (May 2016) image is available from here
https://www.dropbox.com/s/nljhpel7m2y0mvc/pi-gallery-25-may-2016.gz


##Roll Yer Own

Install Raspbian Jessie on at least a 4GB SD card.  It expects to have another partition called VIDEOS as well, make the partition exFat format if you can.  The latest raspbian release has an annoying feature where it takes over the entire card on first startup, so install the partition first.

Summary - Format as at least a 4GB raspbian + 4GB+ VIDEOS exfat partition

Install some packages:

`apt-get install exfat-fuse exfat-utils hfsplus hfsprogs hfsutils udisks-glue policykit-1 supervisor`


create file /etc/polkit-1/localauthority/50-local.d/50-mount-as-pi.pkla

```
[Media mounting by pi]
Identity=unix-user:pi
Action=org.freedesktop.udisks.filesystem-mount
ResultAny=yes
```


create /etc/supervisor/conf.d/udisks-glue.conf

```
[program:udisks-glue]
user = pi
command = udisks-glue -f
autostart = true
autorestart = true
stdout_logfile = /var/log/supervisor/udisks-glue-out.log
stderr_logfile = /var/log/supervisor/udisks-glue-err.log
```

Add to the end of /home/pi/.profile

```
RUNLEVEL=$(runlevel | cut -f 2 -d" ")
if [ "$RUNLEVEL" -eq "3" ]
then
    /bin/bash /home/pi/fullscreenvideo.sh
fi
```


Install the script and config file

```
cp fullscreenvideo.sh /home/pi
chmod +x fullscreenvideo.sh
cp config.txt /boot
```

