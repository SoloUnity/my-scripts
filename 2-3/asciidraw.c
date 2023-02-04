/*
Name: Gordon Ng
Email: gordon.ng@mail.mcgill.ca
Department: Software Engineering, Faculty of Science
*/

#include <stdio.h>
#include <string.h>
#include <math.h>
int main() {

	char command[100];	// Initial command array

	int row;						// Stores the row from GRID
 	int column;					// Stores the column from GRID

	int grid[1000][1000];	// Sets a 1000x1000 grid
 	int gridSelected = 0;	// Determines if GRID command is already run

	char pixel = '*';			// Character that is used to draw on the grid

	// While true until END is executed
	while (1) {
		
		scanf("%s", command);	// Obtains the first command field

		if (strcmp(command, "END") == 0) {
			return 0;	// Exits the loop and the program
		}
		else if (strcmp(command,"CHAR") == 0) {
		
			char garbage;

			scanf("%c", &garbage);	// Removes carriage return
			scanf("%c", &pixel);		// Sets the pixel character
			
			while(getchar() != '\n');	// Clears stdin

		}
		else if (strcmp(command,"GRID") == 0) {	
			
			if (gridSelected) {
				printf("GRID was already set to %d,%d \n", row, column); // Prints if row and column are already set
				while(getchar() != '\n');
			}
			else {	
			
				scanf("%d", &row);		// Sets the row from 
				scanf("%d", &column);	// Sets the column 
			
				gridSelected = 1;			// Sets GRID command to already used
			
				// Initialise the grid with empty space
				for (int x=0; x < column; x++) {
					for (int y=0; y < row; y++) {
						grid[x][y] = ' ';
					}
				}

				while(getchar() != '\n');
			}
		}
		else if (gridSelected) {
			if (strcmp(command,"RECTANGLE") == 0) {
				// Draws a rectangle at the coordinates
				
				// Coordinate points
				int x1,x2,y1,y2;

				scanf("%d,%d",&x1,&y1);
				scanf("%d,%d",&x2,&y2);
				
				// Draws top line
				for (int x=x1; x <= x2;x++) {
					if ((y1 <= 999) && (x <= 999)) {
						grid[y1][x] = pixel;
					}
				}

				// Draws bottom line
				for (int x=x1; x <= x2;x++) {
        	if ((y2 <= 999) && (x <= 999)) {
						grid[y2][x] = pixel;
      		}
				}

				// Draws left line
				for (int y=y2; y <= y1;y++) {
					if ((y <= 999) && (x1 <= 999)) {	
						grid[y][x1] = pixel;
					}
				}
			
				// Draws right line
				for (int y=y2; y <= y1;y++) {
         if ((y <= 999) && (x2 <= 999)) { 
						grid[y][x2] = pixel;
        	}
				}

    		while(getchar() != '\n');
			}
    	else if (strcmp(command,"LINE") == 0) {
      	// Draws a line between two points
				
				// Coordinate points
				int x1,x2,y1,y2;
				
        scanf("%d,%d",&x1,&y1);
        scanf("%d,%d",&x2,&y2);

				int dx = x2 - x1;
    		int dy = y2 - y1;

    		// Increments of x and y for the loops below
    		int sx;
    		int sy;

				// Determining sign of x and y
				if (dx < 0) {
					sx = -1;
				}
				else if (dx > 0) {
					sx = 1;
				}
				else {
					sx = 0;
				}
				
				if (dy < 0) {
					sy = -1;
				}
				else if (dy > 0) {
					sy = 1;
				}
				else {
					sy = 0;
				}
    		
				
				// Absolute value of the deltas
    		dx = fabs(dx);
				dy = fabs(dy);

				int d; 
				
				// Custom max control flow as fmax does not work
				if (dx > dy) {
					d = dx;
				}
				else if (dy > dx) {
					d = dy;
				}
				else {
					d = dx;
				}

    		// Initial remainder
    		double r = d / 2;	// Used to increment across axises to determine when to increment either the x or y axis

    		int X = x1;
    		int Y = y1;

				if ((x1 == x2) && (y1 == y2)) {
					// Special point case
					if ((y1 <= 999) && (x1 <= 999)) {
						grid[y1][x1] = pixel;
					}
				}
    		else if(dx > dy) {   

					// Drawing pixels by incrementing the X axis
        	for(int i = 0; i <= d; i++) {
						if ((Y <= 999) && (X <= 999)) {
          		grid[Y][X] = pixel;
            }
						// Updating x axis and remainder
            X += sx; 
						r += dy; 

						// Updating y axis and remainder
            if (r >= dx) {
            	Y += sy; 
             	r -= dx; 
          	}
        	}
    		}
    		else {   
        	
					// Drawing pixels by incrementing the Y axis
        	for(int i = 0; i <= d; i++) {    
          	if ((Y <= 999) && (X <= 999)) {
							grid[Y][X] = pixel;
            }
						// Updating y axis and remainder
            Y += sy; 
            r += dx;

						// Updating x axis and remainder
         		if(r >= dy) {    
            	X += sx; 
              r -= dy;
         		}
        	}
    		}

				while(getchar() != '\n');
			}
    	else if (strcmp(command,"CIRCLE") == 0) {
      	
				int xMiddle,yMiddle,r;

        scanf("%d,%d",&xMiddle,&yMiddle);
        scanf("%d",&r);
					
				// Implementation of Mid-Point Circle algorithm
				
				int x = r; 	// x stepper
				int y = 0;	// y stepper
				int z  = 0;	// z represents the function (x^2 + y^2 - r^2), it determines if the generated circle point is inside the actual circle 
				
					
				while (x >= y) {
					
					
					// Drawing each pixel
					// Seperated the circle in 8 pieces and drawing from one piece to another
					if (((yMiddle + y) <= 999) && ((xMiddle + x) <= 999) && ((yMiddle + y) >= 0) && ((xMiddle + x) >= 0)) {
          	grid[yMiddle + y][xMiddle + x] = pixel;
					}	
					
					if (((yMiddle + x) <= 999) && ((xMiddle + y) <= 999) && ((yMiddle + x) >= 0) && ((xMiddle + y) >= 0)) {
            grid[yMiddle + x][xMiddle + y] = pixel;
          }

					if (((yMiddle + x) <= 999) && ((xMiddle - y) <= 999) && ((yMiddle + x) >= 0) && ((xMiddle - y) >= 0)) {
            grid[yMiddle + x][xMiddle - y] = pixel;
          }

					if (((yMiddle + y) <= 999) && ((xMiddle - x) <= 999) && ((yMiddle + y) >= 0) && ((xMiddle - x) >= 0)) {
            grid[yMiddle + y][xMiddle - x] = pixel;
          }

					if (((yMiddle - y) <= 999) && ((xMiddle - x) <= 999) && ((yMiddle - y) >= 0) && ((xMiddle - x) >= 0)) {
            grid[yMiddle - y][xMiddle - x] = pixel;
          }

					if (((yMiddle - x) <= 999) && ((xMiddle - y) <= 999) && ((yMiddle - x) >= 0) && ((xMiddle - y) >= 0)) {
            grid[yMiddle - x][xMiddle - y] = pixel;
          }

					if (((yMiddle - x) <= 999) && ((xMiddle + y) <= 999) && ((yMiddle - x) >= 0) && ((xMiddle + y) >= 0)) {
            grid[yMiddle - x][xMiddle + y] = pixel;
          }

					if (((yMiddle - y) <= 999) && ((xMiddle + x) <= 999) && ((yMiddle - y) >= 0) && ((xMiddle + x) >= 0)) {
            grid[yMiddle - y][xMiddle + x] = pixel;
          }
					

					if (z <= 0) {
						// The generated point is inside the circle
						y++;
						z = z + 2 * y + 1;
					}
					if (z > 0) {
						// The generated point is outside the circle
						x--;
						z = z - 2 * x + 1;
					}
				}
				while(getchar() != '\n');
			}
			else if (strcmp(command,"DISPLAY") == 0) {
      	// Displays a grid of drawings
      	for(int y=column-1; y >= -1; y--) {

        	// Prints the y axis numbers
        	if (y != -1) {
						if (y < 10) {
							printf(" ");
						}
          	printf("%d", y);
        	}

        	for(int x=0; x <= row-1; x++) {

          	if (y == -1) { // Prints x axis numbers
            	if (x == 0) {
								printf("   %d", x);
							}
							else if (x < 10) {
								printf("  %d", x);
							}
							else {
              	printf(" %d", x);
            	}
          	}
          	else {
            	// Prints whats in the grid
            	printf(" %c ", grid[y][x]);
						}
        	}

        	puts("\0");
      	}

      	while(getchar() != '\n');
    	}
			else {
				printf("Error did not understand %s\n", command);
				while(getchar() != '\n');
			}
		}
		else if (!gridSelected){
			
			if ((strcmp(command,"DISPLAY") == 0) || (strcmp(command,"CIRCLE") == 0) || (strcmp(command,"RECTANGLE") == 0) || (strcmp(command,"LINE") == 0)) {
				printf("Only CHAR command is allowed before the grid size is set.\n");
			}
			else {
				printf("Error did not understand %s\n", command);
			}
			while(getchar() != '\n');
		
		}
	}
}
