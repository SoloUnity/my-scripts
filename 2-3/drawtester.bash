#!/bin/bash

# Name: Gordon Ng
# Email: gordon.ng@mail.mcgill.ca
# Department: Software Engineering, Faculty of Science

if [[ ! -f asciidraw.c ]]
then
	echo "Error cannot locate asciidraw.c"
	exit 1
fi

gcc -o asciidraw asciidraw.c -lm
rc=$?

if [[ $rc -ne 0 ]]
then
	echo "There were errors/warnings from gcc. rc = $rc"
	exit $rc
fi

# Tests invalid commands
echo " --- 1) test case to reject GRID as it is already set ---"
echo '
./asciidraw <<ENDOFCMDS
LINE 5,5
GRID 5 5
GRID 20 40
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
LINE 5,5
GRID 5 5
GRID 20 40
END
ENDOFCMDS

#Tests the DISPLAY command 
echo " --- 2) test DISPLAY command ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 50 50
DISPLAY
LINE 0,0 4,4
DISPLAY
LINE 1,0 3,0
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 50 50
DISPLAY
LINE 0,0 4,4
DISPLAY
LINE 1,0 3,0
DISPLAY
END
ENDOFCMDS

# Tests RECTANGLE command
echo " --- 3) test RECTANGLE command ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 10 10
RECTANGLE 1,8 8,1
RECTANGLE 3,6 6,3
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 10 10
RECTANGLE 1,8 8,1
RECTANGLE 3,6 6,3	
DISPLAY
END
ENDOFCMDS

# Tests LINE command including vertical, horizontal, positive and negative cases
echo " --- 4) test LINE command ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 20 20
LINE 1,1 11,11
LINE 16,14 4,2
LINE 1,10 10,10
LINE 10,1 17,6
LINE 15,18 19,1
LINE 0,0 0,19
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 20 20
LINE 1,1 11,11
LINE 16,14 4,2
LINE 1,10 10,10
LINE 10,1 17,6
LINE 15,18 19,1
LINE 0,0 0,19
DISPLAY
END
ENDOFCMDS

# Tests CIRCLE command including out of bounds cases
echo " --- 5) test CIRCLE command ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 30 30
CIRCLE 15,15 14
CIRCLE 0,0 20
CIRCLE 29,29 20
CIRCLE 18,18 0
CIRCLE 9,9 1
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 30 30
CIRCLE 15,15 14
CIRCLE 0,0 20
CIRCLE 29,29 20
CIRCLE 18,18 0
CIRCLE 9,9 1
DISPLAY
END
ENDOFCMDS

# Tests truncation behaviour of all drawing commands
echo " --- 6) test truncation of drawings ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 30 30
LINE 10,10 80,20
CIRCLE 29,29 20
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 30 30
LINE 10,10 80,20
CIRCLE 29,29 20
RECTANGLE 0,100 100,0
DISPLAY
END
ENDOFCMDS

# Tests the calling of COMMANDS with bounds outside the rid
echo " --- 7) Out of grid bounds test  ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 50 50
LINE 10,10 4000,2000
CIRCLE 0,0 2000
RECTANGLE 4000,3000 4500,2500
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 50 50
LINE 10,10 4000,2000
CIRCLE 0,0 2000
RECTANGLE 4000,3000 4500,2500
DISPLAY
END
ENDOFCMDS

# Test point cases of commands
echo " --- 8) Point cases test  ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 10 10
LINE 1,1 1,1
RECTANGLE 5,5 5,5
CIRCLE 7,7 0
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 10 10
LINE 1,1 1,1
RECTANGLE 5,5 5,5
CIRCLE 7,7 0
DISPLAY
END
ENDOFCMDS

# Changing Char test
echo " --- 9) CHAR command test ---"
echo '
./asciidraw <<ENDOFCMDS
GRID 10 10
CHAR 0
LINE 5,5 5,5
RECTANGLE 5,6 5,6
CIRCLE 5,7 0
CHAR -
LINE 4,5 4,5
RECTANGLE 4,6 4,6
CIRCLE 4,7 0
DISPLAY
END
ENDOFCMDS
'

./asciidraw <<ENDOFCMDS
GRID 10 10
CHAR 0
LINE 5,5 5,5
RECTANGLE 5,6 5,6
CIRCLE 5,7 0
CHAR -
LINE 4,5 4,5
RECTANGLE 4,6 4,6
CIRCLE 4,7 0
DISPLAY
END
ENDOFCMDS

# General all purpose test, including overwrite, truncation, char changing and all drawing commands
echo " --- 10) test case to draw multiple shapes, switching characters, truncation, overlap, etc...  --- "
echo '
./asciidraw <<ENDOFCMDS
GRID 40 40
LINE 20,20 25,30
CHAR +
CIRCLE 25,25 10
DISPLAY
LINE 10,10 15,20
CHAR %
RECTANGLE 30,45 35,35
DISPLAY
RECTANGLE 0,39 39,0
RECTANGLE 20,25 50, 10
LINE 0,100 39,0
DISPLAY
END
ENDOFCMDS
'
./asciidraw <<ENDOFCMDS
GRID 40 40
LINE 20,20 25,30
CHAR +
CIRCLE 25,25 10
DISPLAY
LINE 10,10 15,20
CHAR %
RECTANGLE 30,45 35,35
DISPLAY
RECTANGLE 0,39 39,0
RECTANGLE 20,25 50, 10
LINE 0,100 39,0
DISPLAY
END
ENDOFCMDS
