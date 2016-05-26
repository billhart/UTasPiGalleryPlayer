#!/bin/bash
declare -A vids

BAIL=""
FILES=$(ls -d /media/*/ | grep -v "pi" 2>/dev/null)
while [ -z "$FILES" ] && [ -z "$BAIL" ]; do
	echo "Searching for media...\n"
	read -t1 -p"Enter return to exit to shell...\n" BAIL
	FILES=$(ls -d /media/*/ | grep -v "pi" 2>/dev/null)
done
if [ -z "$BAIL" ]
then
	echo "Media Found...",$FILES
#Make a newline a delimiter instead of a space
	SAVEIFS=$IFS
	IFS=$'\n'

	for f in `ls -d /media/*/ | grep -v "VIDEOS" | grep -v "pi"`
	do
		FILES="$f"
	done

	if [ -z "$FILES" ]
	then
		FILES='/media/VIDEOS/'
	fi

	current=0
	for f in `ls $FILES | grep -i -e .mp4$ -e .avi$ -e .mkv$ -e .mp3$ -e .mov$ -e .mpg$ -e .flv$ -e .m4v$ -e .3gp$ -e .wav$ -e .aiff$ -e .wmv$`
	do
	        vids[$current]="$f"
	        let current+=1
		#echo "$f"
	done
	max=$current
#/usr/bin/setterm --background black --foreground black
#	/usr/bin/setterm -blank force
	current=0
	if [ "$max" -gt 0 ]
	then
		/usr/bin/setterm -blank force
		while true; do
			if pgrep omxplayer > /dev/null
			then
				echo 'running'
			else
				if [ $max -eq 1 ]
				then
					/usr/bin/omxplayer --loop --no-osd --blank -o both --vol 0 "$FILES${vids[0]}" # --no-keys
				else
					let current+=1
					if [ $current -ge $max ]
					then
						current=0
					fi
					/usr/bin/omxplayer --no-osd --blank  -o both --vol 0 "$FILES${vids[$current]}" # --no-keys
				fi
			fi
		done
	else
		echo "No Videos Found to Play"
	fi
else
	echo "Quitting..."
fi
#Reset the IFS
IFS=$SAVEIFS
