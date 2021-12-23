#!/bin/bash

# Update songs list
echo "Updating song list"
curl -s -S https://raw.githubusercontent.com/gpask/swipe-jukebox/master/songs.txt > songs.txt

echo "Jukebox started!"

while read -ep "Swipe: " INPUT; do
	# Swipe input contains track delimiters, let's extract just the first number and use it
	read -a ID <<< "${INPUT//[^0-9]/ }"

	# No number found, bail
	if [[ -z "$ID" ]]; then
		continue
	fi

	# Trim leading zeros so it doesn't think this is octal or whatever
	ID=$( echo $ID | sed 's/^0*//' )

	# a card for starting and stopping
	if [[ "$ID" -eq "999" ]]; then
		mpc toggle
		continue
	fi
	
	# a card to clear the entire queue except for the current song
	if [[ "$ID" -eq "998" ]]; then
		mpc crop
		continue
	fi

	# Grab the appropriate line from the song list
	URI=$( sed "${ID}q;d" songs.txt )

	if [[ -z "$URI" ]]; then
		continue
	fi

	mpc add "$URI" 
done
