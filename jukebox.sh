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
	
	# a card to clear the entire queue
	if [[ "$ID" -eq "998" ]]; then
		mpc clear
		continue
	fi

	# Grab the appropriate line from the song list
	URI=$( sed "${ID}q;d" songs.txt )

	if [[ -z "$URI" ]]; then
		continue
	fi
	# Add swipe to queue
		mpc add "$URI"

	# How many things are in the queue?
	COUNT=$( mpc playlist | wc -l )

	# If there's only one thing in the queue, that means it was just added so start playing.
	# Otherwise it will restart the currently playing track instead of continuing on with the playlist.
	if [[ "$COUNT" -eq 1 ]]; then
		mpc play
		continue
	fi
	done
