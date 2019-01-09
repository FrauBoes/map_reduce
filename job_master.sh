#!/bin/bash

# Check that an argument is given
if [ $# -ne 1 ]; then
	echo "Please include a directory as argument."
	exit 1
fi

# Part 1: map
# Assign number of files in $1 to variable
no_maps=$( ls $1 | wc -l )

# Create pipe for map function
mkfifo map_pipe

# Start a map process for each file in $1
for file in `ls $1` ; do
	./map.sh "$1$file" &
done

# Set counter variable for maps finished
no_maps_received=0

# Listen to map_pipe
while [ $no_maps_received -lt $no_maps ]; do
    read input_map < map_pipe
    if [ "$input_map" = "map finished" ] ; then
    	let "no_maps_received=$no_maps_received+1"
	else	
		# Write keys to keys file
		if ! grep -q "$input_map" keys ; then
        	echo "$input_map" >> keys
		fi
	fi
done

# Remove map_pipe
rm map_pipe

# Part 2: reduce
# Create pipe for reduce function
mkfifo reduce_pipe

# Set counter variable for reducers to start
no_reduce=0

# Set counter variable for reducers finished
no_reduce_received=0

file=keys

# Go through keys file. Start reducers according to number of keys
while read line; do
	let "no_reduce=$no_reduce+1"
	./reduce.sh "$line" &
done <$file

# Listen to reduce_pipe
while [ $no_reduce_received -lt $no_reduce ]; do
    read input_reduce < reduce_pipe
    # Print key/value pair to console
	echo "$input_reduce"
    let "no_reduce_received=$no_reduce_received+1"
done

# Remove reduce_pipe
rm reduce_pipe


