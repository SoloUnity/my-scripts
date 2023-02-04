#!/bin/bash

# Name: Gordon Ng
# Email: gordon.ng@mail.mcgill.ca
# Department: Software Engineering, Faculty of Science

list=$@

# Determines if there is correct number of arguments
if [[ ($# = 2) || ($# = 3) ]]
then

	L=0  			# Stores if -l was run
	File="" 		# Stores the file name if valid and preceded by -f
	F=0			# Stores if -f was inputed
	largestNum=0		# Stores the largest number if -l was called

	# Iterate over the inputs 
	for var in $list
	do
		# Set L to 1 if -l is an input, sets F to 0 to signify that there is no -f input at that index 
		if [[ $var = "-l" ]]
		then
			L=1
			F=0
		# Sets File to name of $var if previous indice is -f as marked by F
		elif [[ $F = 1 ]]
		then
			File=$var
		fi

		# Set F to 1 if the input is -f
		if [[ $var = "-f" ]]
		then
			# Check if -f is called twice consecutively
	       		if [[ ! $F = 1 ]]
			then
				F=1
			else
				echo "Usage: primechk.bash -f <numbersfile> [-l]"
                		exit 1
			fi	
		fi

	done

	# Declare incorrect usage if there is no file output
	if [[ $File = "" ]]
	then

		echo "Usage: primechk.bash -f <numbersfile> [-l]"
               	exit 1
	
	# Determine if the input file $File exists
	elif [[ ! -f $File ]]
	then
		echo "Input file $File does not exist"
                exit 2
	else

		# Iterate over lines in the file
		while read num
		do
			# Filter for special characters and the number range
			if [[ (! $num =~ [^0-9]) && ($num -gt 1) && ($num -lt 1000000000000000000) ]]
                        then
                                /home/2013/jdsilv2/206/mini2/primechk $num > /dev/null
					
				# Determine if the executed script was a success
				if [[ $? = 0 ]]
				then
					# Logic for determining largest prime number if -l was inputed, otherwise echo the prime number
					if [[ ($L = 1) && ($num -gt $largestNum) ]]
					then
						largestNum=$num
					elif [[ $L = 0 ]]
					then
						echo $num
					fi
				fi
                        fi
		done < $File
	
		# Echo the final largest prime if -l was inputed originally
		if [[ ($L = 1) && (! $largestNum = 0) ]]
		then 
			echo $largestNum
		fi

	fi
else
	echo "Usage: primechk.bash -f <numbersfile> [-l]"
        exit 1
fi

