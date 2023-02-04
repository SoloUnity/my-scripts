#!/bin/bash

# Name: Gordon Ng
# Email: gordon.ng@mail.mcgill.ca
# Department: Software Engineering, Faculty of Science


# If statements detect correct use case
if [[ $# -ne 1 ]]
then
        echo "Usage ./logparser.bash <logdir>"
        exit 1
elif [[ !(-d $1) ]]
then
	echo Error: /tas/r is not a valid directory name 1>&2
        exit 2
fi

# Create file
touch logdata.csv

# allFile is a variable that will contain the contents of every file in the directory
allFile=""
for file in `find $1 -name  *.*.log`
do
	# fileName and fileFormat obtains and modifies the file name to match its respective process
	fileName=$(basename $file)
        fileFormat=${fileName/./:}
	

	allFile+=$'\n'"Now file: $fileFormat"$'\n'	# Adds a header so different files / processes can be distinguished
	allFile+=$(cat $file)				# Add countent of file to allFile
done
	
awk '
# count1 is the index counter for broadcasts, count2 is the index counter for runs, count3 is the index counter for delivers
BEGIN {count1=0;count2=0;count3=0;fileName=""; OFS=",";}
{

	if ($1 == "Now") {
		# This is the header, which is passed in as the current file / process
		fileName=$3
	}
	else if ($7 == "broadcastMsg") {
		# This is for broadcasts
        	broadcastList[count1]["process"]=substr(fileName, 1, length(fileName)-4)	# Formats and sets the file name as the process name
               	broadcastList[count1]["time"]=$4						# Time of broadcast
               	broadcastList[count1]["messageid"]=$NF						# Broadcast message id
		count1+=1
        }
	else if (($6 == "DISLXXX.gcl.GCL$GCLInbox") && (NF == 15) && ($NF != "[senderProcess:CLOSE:val:null]")) {
         	# This is for runs / receiver
		runList[count2]["process"]=substr(fileName, 1, length(fileName)-4)		# Formats and sets the file name as the process name
             	runList[count2]["time"]=$4							# Time of received message
		split($NF,messageID,":")							# Formatting to obtain the message id
		unformatted=messageID[5]
		runList[count2]["messageid"]=substr(unformatted, 1, length(unformatted)-1)	# Message id
		runList[count2]["senderProcess"]=substr($9, 1, length($9)-1)			# Name of the process that sent message
		count2+=1
     	}
        else if (($7 == "deliver") && ($9 == "Received")) {
		# This is for delivers
        	deliverList[count3]["process"]=substr(fileName, 1, length(fileName)-4)		# Formats and sets the file name as the process name
		deliverList[count3]["time"]=$4							# Time of delivered message
		deliverList[count3]["messageid"]=substr($10, 2)					# Message id with formatting
               	deliverList[count3]["senderProcess"]=$NF					# Name of the process that delivered message
		count3+=1
      	}
}
END {

	# Loops over all broadcasts instances
	for (counter1=0; counter1 < count1; counter1++) {
		
		# These variables are what will be printed / added to the log file
		broadcastSendProcess=broadcastList[counter1]["process"]				# Name of the broadcast process
		sendTime=broadcastList[counter1]["time"]					# Time of broadcast
		sendMessageID=broadcastList[counter1]["messageid"]				# Message id
		runTime=""									# Time of run / receive
		runProcess=""									# Name of run / receive process
		deliverTime=""									# Time of delivery
	
		# Loops over all runs / receives instances
		for (counter2=0; counter2 < count2; counter2++) {
			
			# These variables are used for comparison and to modify the variables in the loop above
			runProcess=runList[counter2]["process"]					# Set above the name of the receive process
			runSendProcess=runList[counter2]["senderProcess"]			# Name of the process that sent this instances message
			runMessageID=runList[counter2]["messageid"]				# Message id of the process that sent this instances message
			
			# If statement compares this receive instances characteristics with the instance of the broadcast above
			if ((runSendProcess == broadcastSendProcess) && (sendMessageID == runMessageID)) {
				
				runTime=runList[counter2]["time"]				# Set above the time received
				
				# Loops over all delivery instances
				for (counter3=0; counter3 < count3; counter3++) {
					
					# These variables are used for comparison and to modify the variables in the loop above
					deliverProcess=deliverList[counter3]["process"]		# Name of this instances deliver process
					deliverSendProcess=deliverList[counter3]["senderProcess"]	# Name of this instances broadcast process which sent the message
					deliverMessageID=deliverList[counter3]["messageid"]	# Message id of this instances broadcast message
						
					# If statement compares this receive instances characteristics with the instance of the receive / run  above
					if ((deliverSendProcess == runSendProcess) && (deliverProcess == runProcess) && (deliverMessageID == runMessageID)) {
							
						deliverTime=deliverList[counter3]["time"]	# Set the delivery time in the first loop
						break						# Break in case of similar processes
					}
					else {
						deliverTime=""					# Resets deliverTime variable in case the delivery time does not exist
					}
				}
				
				# Prints the required variables to add to the logdata file 
				print broadcastSendProcess,sendMessageID,runProcess,sendTime,runTime,deliverTime
				
			}	
		}

	}

}
' <<< "$allFile" > "logdata.csv"	# Pass in the variable containing all files to awk and adding the output to the logdata file
	
# Sort the logdata file 
sort -t ',' -k1,1 -k2,2n -k3,3 -o logdata.csv logdata.csv

# Create a new stats file
touch stats.csv

awk '
# currentMessage and currentProcess are used to differentiate the number of messages sent, count1 is the index counter for the number of broadcast processes, count2 is the index counter for the number receive processes
BEGIN{
	FS=",";currentProccess="";currentMessage="";count1=0;count2=0
}
{
	# Logic to intialize the array for the number of that process
	if (currentProcess != $1) {
		currentProcess = $1
		msgCount[currentProcess]=0
	}

	# If the message changes, adds 1 to the number of its messages
	if (currentMessage != $2) {
		currentMessage = $2
		msgCount[currentProcess]+=1
	}

	# If the broadcast array is not initalised, initialise it
	if (broadcastExists[$1]=="") {
		broadcastExists[$1]=1			# Mark as process exists
		broadcastListName[count1]=$1		# Save the name of this process
		count1+=1				# Add 1 to the number of unique broadcast processes
	}

	# If the receive array is not initalised, initialise it
	if (receiverExists[$3]=="") {
		receiverExists[$3]=1			# Mark as process exists
		receiverListName[count2]=$3		# Save the name of this process
		count2+=1				# Add 1 to the number of unique receive processes
	}

	# This if else statement is to obtain the number of successful and total delivers
	# If the receive array is not initalised, initialise it
	if (receiverList[$1][$3]=="") {
		receiverList[$1][$3]=1
		if ($6 != "") {
			deliveredList[$1][$3]=1	
		}
	}
	else {
		receiverList[$1][$3]+=1			# Adds 1 to the number of total deliver attempts
		if ($6 != "") {
                 	deliveredList[$1][$3]+=1	# Adds 1 to the number of successful delivers
                }
	}

}
END{
	OFS=","
	rowCount=0
	columnCount=0
	header="broadcaster,nummsgs"

	# Loops over receiver processes names for the header
	for (counter1=0; counter1 < count2; counter1++) {
		
		receiverProcessName=receiverListName[counter1]
		header = header ","
		header = header receiverProcessName
	}

	# Prints the header to the stats csv file
	print header

	# Loops over the broadcast processes names and creates a row with the information of that process
	for (counter1=0; counter1 < count1; counter1++) {

		broadcastProcessName=broadcastListName[counter1] 	# Current broadcast processes name
		row[counter1]=broadcastProcessName			# Add the name to the row statement that will be printed
		nummsgs=msgCount[broadcastProcessName]			# Number of messages sent by that process
		
		# Redundant if statement because i was too lazy to check my logic
		if (nummsgs == "") {
			row[counter1]=row[counter1] ","	
			row[counter1]=row[counter1] "0"
		}
		else  {
			row[counter1]=row[counter1] ","			# Add the number of messages to the row statement that will be printed
			row[counter1]=row[counter1] nummsgs
		}

		# Loops over receiver processes names 
		for (counter2=0; counter2 < count2; counter2++) {
			
			receiverProcessName=receiverListName[counter2]					# Current receive processes name
			allAttempts=receiverList[broadcastProcessName][receiverProcessName]		# Number of attempted delivers
			successfulAttempts=deliveredList[broadcastProcessName][receiverProcessName]	# Number of successful delivers
			
			# More if statements because im too lzay to check code logic
			if (allAttempts != 0) {
				percentage=(successfulAttempts/allAttempts) * 100
                        	row[counter1]=row[counter1] ","
                        	row[counter1]=row[counter1] percentage					# Add the efficiency of this column to the row that will be printed
			}
			else {
				row[counter1]=row[counter1] ","
				row[counter1]=row[counter1] "N/A"
			}
		}
	}
	
	# Loops over all rows that were made above and prints them to the stats csv file
	for (counter1=0; counter1 < count1; counter1++) {
		print row[counter1]
	}


}
' < "logdata.csv" > "stats.csv"

# Create new HTML file
touch stats.html

awk '
BEGIN{
	FS=","
	print "<HTML>"
	print "<BODY>"
	print "<H2>GC Efficiency</H2>"
	print "<TABLE>"
}
{
	row = "<TR>"
	
	# Loops over the row and adds the tags for each column element
	for (counter1=1; counter1 <= NF; counter1++) {
		row = row "<TD>"
		row = row $counter1
		row = row "</TD>"
	}
	row = row "<TR>"
	print row
}
END{
	print "</TABLE>"
	print "</BODY>"
	print "</HTML>"
}
' < "stats.csv" > "stats.html"
