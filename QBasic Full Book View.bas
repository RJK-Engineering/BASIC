'-----------------
INPUT "What is your name"; name$ 'Question mark added

'-----------------
INPUT "What is your age", age 'No question mark added

'-----------------
CLS
INPUT "What is your name"; name$
PRINT "Hello, "; name$; "donkey"
INPUT "How old are you"; age
INPUT "What is your best computer game?", game$
PRINT "     name:"; name$
PRINT "      age:"; age; " years old"
PRINT "best game:"; game$

'-----------------
INPUT #file_stream, variable1 ; variable2$ 'more variables can be taken.

'-----------------
LINE INPUT 1,file_line '1 is the file stream number. Can be any other number too.

'-----------------
PRINT "Hello World"

'-----------------
PRINT "This line will be erased"
CLS
PRINT "Hello";
PRINT " World",
PRINT "Hello Jupiter"
PRINT "Good Bye",,"For";" Now"
PRINT 1,2,3,4,5

'-----------------
CLS
hello$ = "Hello World"
number = 12
PRINT hello$, number

'-----------------
CLS
LOCATE 14, 34     'position the left eye
PRINT "<=>"       'draw the left eye
LOCATE 14, 43     'position the right eye
PRINT "<=>"       'draw the right eye
LOCATE 16, 39     'position the nose
PRINT "o|o"       'draw the nose
LOCATE 18, 36     'position the mouth
PRINT "\_______/" 'draw the mouth
LOCATE 19, 42     'the bottom
PRINT "The Face by QBasic"

'-----------------
CLS

LOCATE 14, 34
COLOR 9
PRINT "<=>"

LOCATE 14, 43
PRINT "<=>"

COLOR 11
LOCATE 16, 39
PRINT "o|o"

COLOR 4
LOCATE 18, 36
PRINT "\_______/"

COLOR 20
LOCATE 19, 42
PRINT "U"

LOCATE 1, 1
COLOR 16, 1
PRINT "Hello World"

'-----------------
CLS

 'Set a-d to initial values
a = 10
b = 6
c = 3.1415
d = 3.333333

e = a + b
PRINT a; "+"; b; "="; e

f = c * d
PRINT c; "*"; d; "="; f

g = b - c
PRINT b; "-"; c; "="; g

h = b / d
PRINT b; "/"; d; "="; h

i = INT(d)
PRINT "Remove the decimal from "; d; "="; i

'-----------------
CLS
INPUT "Enter a number: ", x
PRINT

x = x + 5
PRINT "X is now: "; x

x = x * x
PRINT "X is now: "; x

x = x / 5
PRINT "X is now: "; x

x = x - 4
PRINT "X is now: "; x

x = x / x
PRINT "X should be 1: "; x

'-----------------
CLS
INPUT "How much is your bill: ", bill
INPUT "What percent tip do you want to give: ", tip

tip = tip / 100   'change percent to decimal
tip = tip * bill  'change decimal to money

PRINT
PRINT "The tip is"; tip; "$."
PRINT "Pay"; tip + bill; "$ total."

'-----------------
  'ORder of OPerations
CLS
a = 15
b = 10
c = 12.2
d = 1.618

PRINT a * b + c   'these two are different
PRINT a * (b + c)

PRINT

PRINT b - c / d   'these two are different
PRINT (b - c) / d

PRINT

PRINT a * b - c * d / a + d   'these two are the same
PRINT (a * b) - ((c * d) / a) + d

'-----------------
CLS
RANDOMIZE TIMER

PRINT "Random number from 0-9:"; RND * 10
PRINT

PRINT "Random number from 1-10:"; (RND * 10) + 1
PRINT

PRINT "Random integer from 1-10:"; INT(RND * 10) + 1
PRINT

PRINT "Random even integer from 50-100:"; INT(RND * 25) * 2 + 50

'-----------------
CLS
RANDOMIZE TIMER

num = INT(RND * 20) + 1

FOR count = 1 TO 5
INPUT "Pick a number between 1 and 20: ", answer
IF answer = num THEN PRINT "You win after";count;"guesses!": END
NEXT
PRINT "You lose"

'-----------------
PRINT "Press any key to continue"
WHILE INKEY$=""
WEND

'-----------------
DO
a$ = inkey$
LOOP WHILE a$=""

'-----------------
DO
x=x+1
LOOP UNTIL x >= 10

'-----------------
CLS
RANDOMIZE TIMER

num = INT(RND * 100) + 1
DO
      INPUT "Pick a number between 1 and 100: ", answer

      IF num = answer THEN PRINT "You Got It!"
      IF num > answer THEN PRINT "Too Small"
      IF num < answer THEN PRINT "Too big"
LOOP UNTIL num = answer
PRINT "Game Over."

'-----------------
CLS
PRINT "WELCOME"
PRINT "I HAVE AN ANSWER FOR ANY OF YOUR QUESTIONS"
10 INPUT "WRITE YOUR QUESTION AND I'LL GIVE YOU AN ANSWER ", question$
RANDOMIZE TIMER
PRINT
answer = INT(RND * 4 + 1)
SELECT CASE answer
    CASE 1
        PRINT "PLEASE REPHRASE YOUR QUESTION."
    CASE 2
        PRINT "YOUR QUESTION IS MEANINGLESS."
    CASE 3
        PRINT "DO YOU THINK I CAN ANSWER THIS?"
    CASE 4
        PRINT "THIS QUESTION LOOKS FUNNY."
END SELECT
PRINT
PRINT "ENTER ANOTHER QUESTION", K$
GOTO 10

'-----------------
DO
    LET k$ = INKEY$
LOOP UNTIL k$ <> ""
SELECT CASE k$
    CASE "q"
        QuitProgram
    CASE "c"
        MakeCircle
    CASE "s"
        MakeSquare
END SELECT

'-----------------
SUB name (params)
{SHARED variables 'if any}
'{code to execute}
' ...
' ...
{STATIC variables 'if any, to be saved for use next time}
END SUB

'-----------------
FUNCTION name (params)
    'Shared variable declarations
    name = result
    '...
END FUNCTION

'-----------------
DIM a AS STRING
DIM b AS INTEGER
DIM c AS LONG
DIM d AS SINGLE
DIM e AS DOUBLE
DIM f AS _INTEGER64 'QB64 only
DIM g AS _FLOAT 'QB64 only

'-----------------
TYPE playertype
name AS STRING
score AS INTEGER
END TYPE

'-----------------
DIM playername AS playertype
playername.name = "Bob"
playername.score = 92

'-----------------
DIM myArray(10) as TYPE 'this is explaining the datatype to be used during program execution in array'

'-----------------
  '$DYNAMIC
DIM myDynamicArray(5) as INTEGER
REDIM myDynamicArray(10) as INTEGER

'-----------------
DIM housenames(25,25) as STRING

'-----------------
DIM deltas(-5 TO 5)

'-----------------
 '$DYNAMIC
ON ERROR GOTO handler 'Prepares the error handler
DIM text(50) AS STRING 'Used to contain the text file.
maxlines = 50 'Contains the current size of the buffer.

DO
CLS 'clears the screen
INPUT "Would you like to create a (N)ew file, (L)oad an existing one, or (E)xit the program"; choice$

SELECT CASE UCASE$(choice$) 'UCASE$ converts strings to UPPER CASE
    CASE "N" 'New file
    CASE "L" 'Load a file
    CASE "E" 'Exit
      CLS
      END
      END SELECT
LOOP 'returns to the top of the program.

handler:
errorflag = ERR  'Keep track of the error that occurred.
RESUME NEXT 'Proceeds with the next statement.

'-----------------
OPEN file$ FOR INPUT AS 1
OPEN file$ FOR OUTPUT AS 2

'-----------------
INPUT #1, a$
PRINT #2, a$

'-----------------
SUB LoadFile
SHARED filename$
SHARED lines, maxlines
SHARED text() AS STRING
SHARED errorflag

INPUT "Enter filename: "; filename$

OPEN filename$ FOR INPUT AS 1
IF errorflag <> 0 THEN
    errorflag = 0
    CLOSE
    PRINT "File not found - press return to continue."
    INPUT "", a$
    EXIT SUB
    END IF

  'Count the number of lines.
  lines = 0
  DO WHILE NOT EOF(1)
    LINE INPUT #1, l$
    lines = lines + 1
    LOOP

  'Allocate enough space for input.
  IF maxlines > lines THEN
    REDIM text(lines + 25) AS STRING
    maxlines = lines + 25
    END IF
    SEEK #1, 1 'Rewind to the beginning of the file.

  'Read the lines into the buffer
  FOR cline = 1 TO lines
    LINE INPUT #1, text(cline)
    NEXT
    CLOSE 1
    errorflag = 0

END SUB

'-----------------
SUB SaveFile (outfile$)
SHARED filename$
SHARED lines, maxlines
SHARED text() AS STRING
SHARED errorflag

IF outfile$ = "" THEN
    LOCATE 1, 1
    INPUT "Enter filename: "; outfile$
    END IF

OPEN outfile$ FOR OUTPUT AS 1
IF errorflag <> 0 THEN
    errorflag = 0
    CLOSE
    PRINT "Couldn't save file - press return to continue."
    INPUT "", a$
    EXIT SUB
    END IF

  'Write each line to the file
  FOR cline = 1 TO lines
    PRINT #1, text(cline)
    NEXT

CLOSE 1
errorflag = 0
filename$ = outfile$

END SUB

'-----------------
OPEN NEWFILE FOR OUTPUT AS #1
CLOSE #1

'-----------------
COLOR 7,0  'Uses the default white on black.
COLOR 15,0 'Bright white on black.
COLOR 0,1  'Black on blue
COLOR 14,0 'Bright yellow.

'-----------------
 'Syntax example
BEEP
PRINT CHR$(07)

'-----------------
rem Music keyboard
do
note$ = inkey$
select case ucase$(note$)
case "A"
Play "A"

case "B"
Play "B"

case "C"
Play "C"

case "D"
Play "D"

case "E"
Play "E"

case "F"
Play "F"

case "G"
Play "G"

end select

loop until ucase$(note$) = "Q"

end

'-----------------
SCREEN 7  'we need to use a graphics enabled screen mode
animation   'calling the sub


SUB animation
    SCREEN 7
    x = 10 'set first x- coordinate
    y = 10 'set first y-coordinate
    DO
        CLS 'going back to a blank screen so that the previous rectangle is erased
        x = x + 3  'setting increment of coordinate x
        y = y + 3   'setting increment of coordinate y

        LINE (x, y)-(x + 5, y) 'drawing lines
        LINE (x, y + 5)-(x + 5, y + 5)
        LINE (x, y)-(x, y + 5)
        LINE (x + 5, y)-(x + 5, y + 5)

        SLEEP 2

    LOOP UNTIL INKEY$ <> ""



END SUB

'-----------------
_mousehide
screen 7

mousetrack

sub mousetrack
do while _mouseinput
cls

X = _mousex
Y = _mousey

LINE (X - 10, Y)-(X + 10, Y), 15
LINE (X, Y - 10)-(X, Y + 10), 15

        IF _MOUSEBUTTON(1) THEN
            IF X > A AND X < A + 25 AND Y > B AND Y < B + 25 THEN
                message$ = "yes"
                goto action
            END IF
        END IF

loop until inkey$ <> ""

'-----------------
Redo:
cls
screen 1
Input "Enter the X-position?";k  'entering coordinates of the screen from where to start.
Input "Enter the Y-position?";l   'this also determines the size of the box.
color 1
for i = 1 to 50 step 2   rem box 'step to ensure space between the boxes, make it one to eliminate the space. The 50 number sets the extension of the box along the z axis
    a = k+i:b = l+i          'this "for-next" loop draws the box over and over again, each with incremented values of k and l.
    line (a,a)-(b,a)
    line (a,b)-(b,b)
    line (a,a)-(a,b)
    line (b,a)-(b,b)
next                            rem diagonals
line (k,k)-(a,a)              'the four diagonals to the structure , which make it more realistic
line (l,l)-(b,b)
line (l,k)-(b,a)
line (k,l)-(a,b)
Input"Do you want to redo? (Y/N)";ans$
if ucase$(ans$)="Y" then goto Redo
end

'-----------------
rem image_display
cls
Dim Image as long
x = 1000  'resolution
y = 1000
Image = _loadimage("TEST.jpg") 'loading the image
screen _newimage(x,y,32) 'putting screen sizes
_putimage (0,0),Image 'putting image

'-----------------
screen _Newimage(1000,1000,256)

'-----------------
Rem calculator
cls
10
print "input first operand"
input a
print "select operation"
print "addition(a)"
print "subtraction(s)"
print "multiplication(m)"
print "division(d)"
print "exponentification(e)"
print "rooting(r)"
print "Quit(q)"
do
next$ = inkey$
loop until next$ <> ""
gosub input_var2

select case next$
case "a"
c = a + b
print "sum is:";c
case "s"
c = a - b
print "Difference is:";c
case "m"
c= a*b
print "Product is :";c
case "d"
c = a/b
print "Quotient is:";c
case "e"
c = a^b
print "Exponentification is:"c
case "r"
c = a^ 1/b
print "Root is:";c
case "q"
end

end select
sleep 3
goto 10







sub input_var
input "enter second operand";b
end sub

'-----------------
SCREEN 7
COLOR 15, 1


_MOUSEHIDE
CLS
LOCATE 5, 1
PRINT "GUNSHOTS"

DO
    NEXT$ = INKEY$
LOOP UNTIL NEXT$ <> ""

CLS
LOCATE 5, 1
PRINT "In this game, you require to bring"
PRINT ""
PRINT "the crosshairs to the box"
PRINT ""
PRINT " , which is the target ,"
PRINT ""
PRINT " and click to shoot it."
PRINT ""
PRINT " In this game , you control"
PRINT ""
PRINT "the crosshairs with your mouse."
PRINT ""
PRINT " You will be given a"
PRINT ""
PRINT " fixed number of tries."
PRINT ""
PRINT " The number of times you hit the target,"
PRINT ""
PRINT " you will be given a point "

DO
    NEXT$ = INKEY$
LOOP UNTIL NEXT$ <> ""




CLS
LOCATE 5, 1
PRINT "Get Ready!"

DO
    NEXT$ = INKEY$
LOOP UNTIL NEXT$ <> ""




10
A = INT(RND * 100)
B = INT(RND * 100)

DO: K$ = INKEY$
    20

    DO WHILE _MOUSEINPUT
        CLS

        IF TRY_COUNT > 30 THEN
            CLS
            LOCATE 10, 1
            PRINT "Remarks:"
            IF POINT_COUNT < 10 THEN PRINT "OH NO! NICE TRY!"
            IF POINT_COUNT > 10 AND POINT_COUNT < 16 THEN PRINT "GOOD WORK!"
            IF POINT_COUNT > 15 AND POINT_COUNT < 21 THEN PRINT "GREAT!"
            IF POINT_COUNT > 20 AND POINT_COUNT < 26 THEN PRINT "AMAZING!"
            END
        END IF



        SECOND = VAL(RIGHT$(TIME$, 2))
        IF PREVSEC <> SECOND THEN
            COUNT = COUNT + 1
        END IF

        LOCATE 25, 25
        PRINT POINT_COUNT









        X = _MOUSEX: Y = _MOUSEY
        LINE (X - 10, Y)-(X + 10, Y), 15
        LINE (X, Y - 10)-(X, Y + 10), 15

        LINE (A, B)-(A + 25, B), 15
        LINE (A, B + 25)-(A + 25, B + 25), 15
        LINE (A, B)-(A, B + 25), 15
        LINE (A + 25, B)-(A + 25, B + 25), 15
        PAINT (A, B), (1), 15

        IF _MOUSEBUTTON(1) THEN
            IF X > A AND X < A + 25 AND Y > B AND Y < B + 25 THEN
                POINT_COUNT = POINT_COUNT + 1
                TRY_COUNT = TRY_COUNT + 1
                GOTO 10
            END IF


        END IF

        IF COUNT > 1 THEN
            COUNT = 0
            TRY_COUNT = TRY_COUNT + 1
            GOTO 10

        END IF



        PREVSEC = SECOND
        GOTO 20



    LOOP
LOOP

'-----------------
REM  Clock
SCREEN 7

CLS
start:
SCREEN 7
_FONT 16
LOCATE 1, 5
PRINT "CLOCK"
PRINT "________________________________________"

LINE (50, 50)-(100, 100), 1, BF
LOCATE 9, 5
PRINT "TIME"
LOCATE 10, 5
PRINT "CONTROL"
LINE (150, 50)-(200, 100), 2, BF
LOCATE 9, 18.5
PRINT "STOP WATCH"



DO

    exit$ = INKEY$
    IF exit$ = "e" OR exit$ = "E" THEN
        CLS
        SCREEN 7
        COLOR 2, 1
        LOCATE 5, 5
        PRINT "YOU HAVE ABORTED THE CLOCK"





        WHILE close_count <> 10
            close_count = close_count + 1
            LOCATE 7, 5
            PRINT "APPLICATION  ";
            IF close_count MOD 2 = 1 THEN
                PRINT "CLOSING >>>   "
            ELSE
                PRINT "CLOSING   >>> "
            END IF




            SLEEP 1
        WEND

        CLS
        SCREEN 7
        COLOR 10, 0
        END
    END IF


    Mouser mx, my, mb
    IF mb THEN
        IF mx >= 50 AND my >= 50 AND mx <= 100 AND my <= 100 THEN 'button down
            DO WHILE mb 'wait for button release
                Mouser mx, my, mb
            LOOP
            'verify mouse still in box area
            IF mx >= 50 AND my >= 50 AND mx <= 100 AND my <= 100 THEN
                GOTO proccess
            END IF
        END IF
    END IF

    Mouser mx, my, mb
    IF mb THEN
        IF mx >= 150 AND my >= 50 AND mx <= 200 AND my <= 100 THEN 'button down
            DO WHILE mb 'wait for button release
                Mouser mx, my, mb
            LOOP
            'verify mouse still in box area
            IF mx >= 150 AND my >= 50 AND mx <= 200 AND my <= 100 THEN
                time_control = 1
                GOTO proccess
            END IF
        END IF
    END IF
LOOP



proccess:

IF time_control = 0 THEN
    time_enter:
    LOCATE 12, 6
    INPUT "enter time"; t
    IF t > 1800 THEN
        mistake = mistake + 1
        IF mistake > 3 THEN
            PRINT "BLOCKED"
            END
        END IF

        GOTO time_enter
    END IF
END IF

Mouser mx, my, mb
IF mb THEN
    IF mx >= 150 AND my >= 50 AND mx <= 200 AND my <= 100 THEN 'button down
        DO WHILE mb 'wait for button release
            Mouser mx, my, mb
        LOOP
        'verify mouse still in box area
        IF mx >= 150 AND my >= 50 AND mx <= 200 AND my <= 100 THEN
            time_control = 1
            GOTO proccess
        END IF
    END IF
END IF



WHILE INKEY$ <> " "
    SLEEP 1
    count = count + 1
    tc = tc + 1
    BEEP
    CLS
    LOCATE 1, 5
    PRINT "CLOCK"
    PRINT "________________________________________"

    IF time_control = 1 THEN
        LINE (150, 50)-(200, 100), 2, BF
    END IF
    LOCATE 3, 5
    PRINT "CURRENT TIME:"; TIME$
    LOCATE 5, 5
    PRINT "MINUTES:"; minute
    LOCATE 6, 5
    PRINT "SECONDS:"; count
    IF count = 60 THEN
        count = 0
        minute = minute + 1
    END IF

    IF time_control = 0 THEN
        LOCATE 8, 5
        PRINT "TIME LEFT:"; (t - tc) \ 60; ":"; (t - tc) MOD 60
        IF tc = t THEN
            BEEP
            BEEP
            BEEP
            BEEP
            END
        END IF
    END IF
    IF time_control = 1 THEN
        Mouser mx, my, mb
        IF mb THEN
            IF mx >= 150 AND my >= 50 AND mx <= 200 AND my <= 100 THEN 'button down
                DO WHILE mb 'wait for button release
                    Mouser mx, my, mb
                LOOP
                'verify mouse still in box area
                IF mx >= 150 AND my >= 50 AND mx <= 200 AND my <= 100 THEN
                    END
                END IF
            END IF
        END IF
        LOCATE 10, 10
        PRINT "PRESS BUTTON TO END"
    END IF

WEND
GOTO start



SUB Mouser (x, y, b)
    mi = _MOUSEINPUT
    b = _MOUSEBUTTON(1)
    x = _MOUSEX
    y = _MOUSEY
END SUB

'-----------------
REM binary
SCREEN 7
COLOR 1, 2

_FONT 16
LOCATE 7, 10
PRINT "Binary Coder"

SLEEP 5

start:

CLS
LOCATE 1, 1
PRINT "Binary coder"
PRINT "_____________"
PRINT ""
PRINT ""
PRINT ""
PRINT ""



INPUT "Enter Decimal number"; a
CLS
LOCATE 1, 1
PRINT "Binary coder"
PRINT "_____________"
PRINT ""
PRINT ""
WHILE a <> 0
    PRINT a MOD 2;
    IF a MOD 2 = 1 THEN
        a = a \ 2
    ELSE a = a / 2
    END IF

WEND
PRINT ""
PRINT ""
PRINT "Binary code is reversed"
WHILE INKEY$ <> " "
WEND
GOTO start

'-----------------
10
RANDOMIZE TIMER
cor = RND * 150
cor2 = CINT(cor)
IF cor2 < 30 AND cor2 > -30 THEN GOTO 10

PRINT "The object to hit is at coordinates"; cor2

INPUT "enter velocity"; v
INPUT "enter angle"; a
d = ((v ^ 2) * SIN(2 * a)) / 10
PRINT "Hit on:"
PRINT CINT(-d)

IF CINT(-d) < cor2 + 30 AND CINT(-d) > cor2 - 30 THEN
    PRINT "Well Done!"
ELSEIF CINT(-d) < 30 AND CINT(-d) > -30 THEN PRINT "Hey , you hit us!"
ELSE PRINT "Ugh, not on target"
END IF

'-----------------
REM ultrasonic_test
CLS
freq = 20000
DO
    PRINT "Frequency is:"; freq

    SOUND freq, 18.2
    INPUT "Can you hear?"; ans$
    IF ans$ = "no" THEN
        freqrange = freq
        GOTO 10
    END IF
    freq = freq + 100
LOOP
10
freq = freqrange
DO
    PRINT "frequency is:"; freq

    SOUND freq, 18.2
    INPUT "can you hear?"; ans$
    IF ans$ = "no" THEN
        PRINT "your max frequency is:"; freq
        END
    END IF
    freq = freq + 2
LOOP
