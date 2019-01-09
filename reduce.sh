#!/bin/bash

# Check that an argument is given
if [ $# -ne 1 ]; then
	echo "Please include a file name as argument."
	exit 1
fi

file=$1

count=0

# Get lines of file as count of items
while read line; do
	let "count=$count+1"
done <$file

# Send key/value pair to job_master 
echo "$file $count" > reduce_pipe

