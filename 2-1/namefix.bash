#!/bin/bash

# Name: Gordon Ng
# Email: gordon.ng@mail.mcgill.ca
# Department: Software Engineering, Faculty of Science

# Determine if there are 2 arguments, if the first input is a file that exists and if both inputs are not links
if [[ ($# != 2) || (! -f $1) || (-h $1) || (-h $2) ]]
then 
	echo "Usage: namefix.bash <inputfile> <outputfile>"
	exit 1
else
	# Determine if the 2nd input is a directory
	if [[ -d $2 ]]
	then
		# Variable representing a file at the second inputed path
		X=$2/$(basename $1)

		# Determine if the directory or c file X already exists, meaning that a new file cannot be written there
		if [[ (-d $X) || (-c $X) ]]
		then 
			echo "The original file name already exists as a directory in the output path"
			exit 4
		# Determine if the output directory cannot be written to
		elif [[ $1 -ef $X ]]
		then
			echo "The $2 directory already contains $(basename $1)"
			exit 2
		elif [[ ! -w $2 ]]
                then
			echo "Output directory $2 cannot be written to"
                        exit 4
		else
			echo "File created in $X"
			/home/2013/jdsilv2/206/mini2/namefix $1 $X
		fi	
	else
		# Variable representing the directory of the second input file
		Y=$(dirname $2)

		# Determine if both inputs are the same file
		if [[ $1 -ef $2 ]]
		then
        		echo "Input and outpout file can not be the same file"
        		exit 2

		# Determine if the first input file exists or cannot be read
		elif [[ ! -r $1 ]]
		then
       			echo "Inputfile $1 cannot be read"
       			exit 3
		
		# Determine if the second input file exists and cannot be written to
		elif [[ (! -w $2) && (-f $2) ]]
		then
        		echo "Outputfile $2 cannot be written to"
        		exit 4

		# Determine if Y cannot be written to and the second input is not an existing file 
		elif [[ (! -w $Y) && (! -f $2) ]]
		then 
			echo "Output directory $Y cannot be written to"
			exit 4
		else
			echo "File created"
			/home/2013/jdsilv2/206/mini2/namefix $1 $2
	
		fi
	fi
fi
