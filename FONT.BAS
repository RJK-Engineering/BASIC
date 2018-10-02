DEFINT A-Z
DECLARE SUB DisplayFonts ()
DECLARE SUB DisplayChar (n, x, y)
DECLARE SUB DisplayString (str AS STRING, x, y)
DECLARE SUB DisplayTable (x, y)
DECLARE SUB DrawStroke (x1, y1, x2, y2)
DECLARE SUB LoadFont (file AS STRING)

TYPE StrokeRecord
    Op AS STRING * 1
    x AS INTEGER
    y AS INTEGER
END TYPE

COMMON SHARED debug, slowDraw
COMMON SHARED recordCount, charCount, charWidth, charHeight
COMMON SHARED StrokeData() AS StrokeRecord
COMMON SHARED CharStart() AS INTEGER ' Start of stroke data
COMMON SHARED CharStop() AS INTEGER ' End of stroke data

CONST OPMOVE = 0
CONST OPDRAW = 1
CONST OPEND = 2

SCREEN 12

'debug = -1
'slowDraw = 500

'LoadFont "MODN.DAT"
'DisplayChar 95, 0, 0 ' "~" = chr(127)
'DisplayString "Hello World!", 0, 0
DisplayFonts

END

DATA "TSCR","TRIP","THIN","SIMP","SCRI","SANS"
DATA "MODN","LITT","LCOM","GOTH","EURO","BOLD"

SUB DisplayFonts STATIC
    DIM Filenames(12) AS STRING * 4
    FOR i = 1 TO 12
        READ Filenames(i)
    NEXT
    FOR i = 1 TO 12
        LoadFont Filenames(i) + ".DAT"
        DisplayTable 0, 40 * (i - 1)
    NEXT
END SUB

SUB DisplayChar (n, x, y) STATIC
    FOR i = CharStart(n) TO CharStop(n)
        SELECT CASE (ASC(StrokeData(i).Op))
        CASE OPDRAW
            x1 = x + posx
            x2 = x + StrokeData(i).x
            y1 = y - posy + charHeight
            y2 = y - StrokeData(i).y + charHeight

            DrawStroke x1, y1, x2, y2
            IF slowDraw THEN FOR c = 1 TO slowDraw: NEXT
        END SELECT

        posx = StrokeData(i).x
        posy = StrokeData(i).y
    NEXT
END SUB

SUB DisplayString (str AS STRING, x, y) STATIC
    FOR i = 1 TO LEN(str)
        DisplayChar ASC(MID$(str, i, 1)) - &H1F, x, 100
        x = x + charWidth
    NEXT
END SUB

SUB DisplayTable (x, y) STATIC
    FOR i = 1 TO charCount
        DisplayChar i, x, y

        IF i = &H30 THEN
            x = x - &H30 * charWidth
            y = y + charHeight
        END IF
        x = x + charWidth
    NEXT
END SUB

SUB DrawStroke (x1, y1, x2, y2) STATIC
    IF debug THEN
        PRINT "LINE ("; x1; ", "; y1; ")-("; x2; ","; y2; ")"
    ELSE
        LINE (x1, y1)-(x2, y2)
    END IF
END SUB

SUB LoadFont (file AS STRING) STATIC
    REDIM StrokeData(1) AS StrokeRecord ' Needed for LEN()

    OPEN file FOR RANDOM AS #1 LEN = LEN(StrokeData(1))
    recordCount = LOF(1) \ LEN(StrokeData(1))
    charCount = &H5F

    IF debug THEN
        PRINT "File length = "; LOF(1)
        PRINT "Record length = "; LEN(StrokeData(1))
        PRINT "Record count = "; recordCount
        PRINT "Character count = "; charCount
    END IF

    charHeight = 20
    charWidth = 12

    REDIM StrokeData(recordCount) AS StrokeRecord
    REDIM CharStart(charCount) AS INTEGER ' Start of stroke data
    REDIM CharStop(charCount) AS INTEGER ' End of stroke data

    ' Load stroke data and character start and stop positions
    char = 1
    CharStart(char) = 0
    FOR i = 1 TO recordCount
        GET #1, i, StrokeData(i)

        ' Next char starts after stroke end operation
        IF ASC(StrokeData(i).Op) = OPEND THEN
            CharStop(char) = i
            char = char + 1

            IF char <= charCount THEN CharStart(char) = i + 1
        END IF
    NEXT
    CLOSE #1

END SUB

