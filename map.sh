#!/bin/bash

# Check that an argument is given
if [ $# -ne 1 ]; then
	echo "Please include a file name as argument."
	exit 1
fi

file=$1

# Go through each line of the file and get the product name of each line
while read line; do
	product_name=$( echo "$line" | cut -d ',' -f2 )

	# Do nothing if there is no product name
	if ! [[ $product_name ]]; then
		continue
	# Exception for 1 case typo
	elif [ "$product_name" = "Product3 " ]; then
		# Append to product file
		echo "Product3 1" >> "Product3"
	# Append product name to respective file
	else 
		# Call P on product file to check if it's free
        ./P.sh "$product_name"
        # Append to product file
		echo "$product_name 1" >> "$product_name"
		# Send key to job_master
		echo "$product_name" > map_pipe	
		# Call V on product file to free it up
		./V.sh "$product_name"
	fi
	
done <$file

# Send message to job_master when finished 
echo "map finished" > map_pipe



