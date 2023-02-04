/*
Name: Gordon Ng
Email: gordon.ng@mail.mcgill.ca
Department: Software Engineering, Faculty of Science
*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// Record / Node for the linked list.
// You MUST use the exact structure. No modification allowed.
typedef struct PersonalInfoRecord
{ 
	char id[10];
	char ptype;
	char name[31];

	union
	{
		struct
		{
			char dept[31];
			int hireyear;
			char tenured;
		}prof;
		struct
		{
			char faculty[31];
			int admyear;
		}stud;
	}info;

	struct PersonalInfoRecord *next;
} PersonalInfoRecord;
//
// Use this in your code as 
// PersonalInfoRecord pir; PersonalInfoRecord *pirp; etc ...
//

// Whatever other functions you need.


// Function for adding a node to the linked list
void addRecord(PersonalInfoRecord **head, char *id, char ptype, char *name, char *faculty, int year, char tenured) {
	PersonalInfoRecord *temp = (PersonalInfoRecord *)malloc(sizeof(PersonalInfoRecord));
	
	// Modify the variables / data of the node
	strncpy(temp->id, id, 10);
  temp->ptype = ptype;
  strncpy(temp->name, name, 31);		
		
	if (ptype == 'P') {
		strncpy(temp->info.prof.dept, faculty, 31);		
		temp->info.prof.hireyear = year;
		temp->info.prof.tenured = tenured;
	}
	else if (ptype == 'S') {
    strncpy(temp->info.stud.faculty, faculty, 31);
    temp->info.stud.admyear = year;
	}

	temp->next = NULL;

	// Create a pointer to head, which will be later used to iterate over the linked list
	PersonalInfoRecord *record = *head;
	
	// This step checks for duplicate IDs aka existing record
	if (*head != NULL) {
		
		// Loop over the linked list
		while(record->next != NULL) {

			// If there is a matching id
    	if (!strcmp(record->id,id)) {

				// Change the variables inside the record provided the new record variable is not empty
    		if (name && (name[0] != '\0')) {
        	strncpy(record->name, name, 31);
      	}

      	if (faculty && (faculty[0] != '\0') && (ptype == 'P')) {
        	strncpy(record->info.prof.dept, faculty, 31);
      	}
      	else if (faculty && (faculty[0] != '\0') && (ptype == 'S')) {
        	strncpy(record->info.stud.faculty, faculty, 31);
      	}

      	if ((year != 0) && (ptype == 'P')) {
        	record->info.prof.hireyear = year;
      	}
      	else if ((year != 0) && (ptype == 'S')) {
        	record->info.stud.admyear = year;
      	}

      	if (tenured && (ptype == 'P') && (tenured != 'E') && (tenured != '\0')) {
        	record->info.prof.tenured = tenured;
      	}

				free(temp);

      	return;
			}
			record = record->next; // Iterate through list
		}

		// Extra block of the code above to catch head and tail case
		if (!strcmp(record->id,id)) {
       	if (name && (name[0] != '\0')) {
         	strncpy(record->name, name, 31);
       	}

       	if (faculty && (faculty[0] != '\0') && (ptype == 'P')) {
         	strncpy(record->info.prof.dept, faculty, 31);
       	}
       	else if (faculty && (faculty[0] != '\0') && (ptype == 'S')) {
         	strncpy(record->info.stud.faculty, faculty, 31);
       	}

       	if ((year != 0) && (ptype == 'P')) {
         	record->info.prof.hireyear = year;
       	}
       	else if ((year != 0) && (ptype == 'S')) {
         	record->info.stud.admyear = year;
       	}

       	if (tenured && (ptype == 'P') && (tenured != 'E') && (tenured != '\0')) {
         	record->info.prof.tenured = tenured;
       	}

				free(temp);

      	return;
     }
	}
	
	// Reset record to head as it will be used again to iterate
	record = *head;
	
	// Head case
	if (*head == NULL || atoi((*head)->id) >= atoi(id)) {	
		// Replace the head with new record, or create new head if head is NULL
		temp->next = *head;
		*head = temp;
	}
	else {

		// Iterates through linked list until it reaches the end or finds an ID larger than the input ID
		while(record->next != NULL && (atoi(record->next->id) < atoi(id))) {
			record = record->next;	
		}		
			
		// Insert the new record in between another record with an id lower than it and an id higher than it
		temp->next = record->next;
		record->next = temp;
	}

}

// Removes a specific node with the designated id
void removeRecord(PersonalInfoRecord **head, char *id) {

	PersonalInfoRecord *record = *head;
	PersonalInfoRecord *prev = NULL;

	// Empty list case
	if (record == NULL) {
		return;
	}
	// Head case
	else if (!strcmp(record->id,id)) {
		*head = record->next;
		free(record);
		return;
	}
	else {
		// Loop through the list until it either reaches the end or finds a matching node with ID or reaches the end
		while(record->next != NULL && strcmp(record->id,id)) {
  		prev = record;
			record = record->next;
		}	
		
		// Case if key is not in list
		if (record == NULL) {
			return;
		}
		else if (prev != NULL) {
			// Case where loop finds appropriate node 
			
			prev->next = record->next;
			free(record);
			return;
		}
	}

}

// Removes all nodes
void removeRecords(PersonalInfoRecord **head) {
	PersonalInfoRecord *record = *head;
	PersonalInfoRecord *nextRecord;

	// Loop through and free all nodes
	while(record != NULL) {
		nextRecord = record->next;
		free(record);
		record = nextRecord;
	}
}

// List out all ndoes or print out 
void list(PersonalInfoRecord *record, char mode, FILE *file) {
	
	// Loop through list given the head node
	while(record != NULL) {

		// Professor case
		if (record->ptype == 'P') {
			if (mode == 'l') { // List mode, print to stdin
				printf("%s,%c,%s,%s,%d,%c\n", record->id, record->ptype, record->name, record->info.prof.dept, record->info.prof.hireyear, record->info.prof.tenured);
			}
			else if (mode == 'f') {	// File mode, print to file
				fprintf(file,"%s,%c,%s,%s,%d,%c\n", record->id, record->ptype, record->name, record->info.prof.dept, record->info.prof.hireyear, record->info.prof.tenured);
			}
		}
		// Student case
		else if (record->ptype == 'S') {
			if (mode == 'l') { // List mode, print to stdin
				printf("%s,%c,%s,%s,%d\n", record->id, record->ptype, record->name, record->info.stud.faculty, record->info.stud.admyear);
			}
			else if (mode == 'f') { // File mode, print to file
				fprintf(file,"%s,%c,%s,%s,%d\n", record->id, record->ptype, record->name, record->info.stud.faculty, record->info.stud.admyear);
			}
		}

		// Iterate through list
		record = record->next;
	}
}



// The main of your application
int main(int argc, char *argv[])
{
	char inputbuffer[100], *input; // to store each input line;
	
	PersonalInfoRecord *head = NULL;	

	// Check if the second argument is valid and if there are 2 arguments
	if ((argv[1] == NULL) || argc != 2) {

		fprintf(stderr, "Error, please pass the database filename as the argument.\n");
		fprintf(stderr, "Usage ./pimapp <dbfile>\n");
		return 1;
	}
	else {

		// Loop and repeadtedly ask for input through stdin	
		while (fgets(input=inputbuffer, 100, stdin) != NULL) {
			
			// Determines the command type
			char *actionType = strsep(&input, ",\n");

			// End case
			if(!strncmp(actionType, "END", 3)) {
				// Open a file and write to it
				char *fileName = argv[1];
				
				FILE *file = fopen(fileName, "wt");

				// Error case for file
				if (file == NULL) {
					printf("Error, unable to open %s for writing\n", fileName);
					removeRecords(&head); // Delete linked list
					return 3;
				}
				else {
					list(head,'f', file);	// Print to file
					removeRecords(&head);	// Delete linked list
					fclose(file);
				}

      	return 0; // We are asked to terminate.
 			}
			else if(!strncmp(actionType, "LIST", 4)) {
				
				// Looping through list and printing
				list(head,'l',NULL);

			}
			else if(!strncmp(actionType, "I", 1) || !strncmp(actionType, "D", 1)) {

				// Get the id of the record
				char *id = strsep(&input, ",\n");
				
				// I / insert command case
				if (!strcmp(actionType, "I")) {

					// Get other parameters for the record
					char *tempPType = strsep(&input, ",\n");
					char ptype = tempPType[0];
					char *name = strsep(&input, ",\n");
      		char *faculty = strsep(&input, ",\n");
					int year = atoi(strsep(&input, ",\n"));
					char tenured;
				
					// Professor case
					if (!strcmp(tempPType, "P")) {

						// Get first character of tenured string and assign it to a char
						tenured = (strsep(&input, ",\n"))[0];
						
						// Add to list
						addRecord(&head, id, ptype, name, faculty, year, tenured);
					}
					// Student case
					else if (!strcmp(tempPType, "S")) {
						
						// Add to list, 'E' signifies empty as tenured will not be used for students
						addRecord(&head, id, ptype, name, faculty, year, 'E');	
					}

				}
				// Deletion case
				else if (!strcmp(actionType, "D")) {
					removeRecord(&head,id); // Remove the record with that id
				}

			}
			else {
				// Catch bucket for all other commands
				printf("Incorrect command\n");
			}
		}
	}
	return 0; // Appropriate return code from this program.	
}

