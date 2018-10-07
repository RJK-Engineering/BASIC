DECLARE SUB Preview (nr%)
DECLARE SUB DisplayChar (n%, x%, y%)
DECLARE SUB DisplayString (str AS STRING, x%, y%)
DECLARE SUB DisplayFonts ()
DECLARE SUB DisplayTable (x%, y%)
DECLARE SUB SetFont (fontName AS STRING, size%)
DECLARE SUB SetFontSize (pixels%)
DECLARE SUB SetScale ()
' Load font SUBs and FUNCTIONs
DECLARE SUB LoadFont (file AS STRING)
DECLARE SUB ProcessVectorData (offset%, remaining%, char%, i%)
DECLARE FUNCTION GetByte% (addr%)
DECLARE FUNCTION GetSignedByte% (addr%)
DECLARE FUNCTION GetShort& (addr%)
DEFINT A-Z

TYPE StrokeFileHeader
    firstChar AS INTEGER
    charCount AS INTEGER
    recordCount AS INTEGER
    top AS INTEGER
    baseline AS INTEGER
    bottom AS INTEGER
    height AS INTEGER
    vectorTableAddr AS INTEGER
    recordOffset AS INTEGER
    widthAddr AS INTEGER
END TYPE

TYPE VectorRecord
    op AS INTEGER
    x AS INTEGER
    y AS INTEGER
END TYPE

COMMON SHARED dir AS STRING
COMMON SHARED slowDraw, fontScale, fontSize, letterSpacing, lineSpacing
COMMON SHARED scale AS DOUBLE
COMMON SHARED Font AS StrokeFileHeader
COMMON SHARED VectorData() AS VectorRecord
COMMON SHARED CharWidth(), CharStart(), CharStop()

CONST CHARCOUNTADDR = &H81
CONST FIRSTCHARADDR = &H84
CONST HEIGHTTOPADDR = &H88
CONST HEIGHTBASELINEADDR = &H89
CONST HEIGHTBOTTOMADDR = &H8A
CONST TABLESADDR = &H90

CONST OPEND = &H0&
CONST OPMOVE = &H80&
CONST OPDRAW = &H8080&

SCREEN 12
CONST DEBUG = 0 ' 0-4
dir = "C:\QUIKMENU\" '"
' slowDraw = 1500
' fontScale = 4
fontSize = 24
letterSpacing = 0: lineSpacing = 1 ' compact

Preview 1
SLEEP 10
CLS
Preview 2
SLEEP 10
CLS
Preview 3

END

DATA "TSCR","TRIP","THIN","SIMP","SCRI","SANS"
DATA "MODN","LITT","LCOM","GOTH","EURO","BOLD"

NoMore:
    END

SUB DisplayChar (n, x, y) STATIC
    FOR i = CharStart(n) TO CharStop(n)
        IF VectorData(i).op = 2 THEN
            x1 = scale * (x + posx)
            x2 = scale * (x + VectorData(i).x)
            y1 = scale * (y - posy + Font.height)
            y2 = scale * (y - VectorData(i).y + Font.height)

            IF DEBUG = 0 THEN
                LINE (x1, y1)-(x2, y2)
            ELSEIF DEBUG >= 4 THEN
                PRINT "LINE ("; x1; ", "; y1; ")-("; x2; ","; y2; ")"
            END IF

            IF slowDraw THEN FOR c = 1 TO slowDraw: NEXT
        END IF

        posx = VectorData(i).x
        posy = VectorData(i).y
    NEXT
END SUB

SUB DisplayFonts STATIC
    DIM filename AS STRING * 4
    DIM currFont AS STRING * 4

    IF DEBUG = 0 THEN VIEW PRINT 30 TO 30

    ON ERROR GOTO NoMore

    FOR i = 1 TO 100
        READ filename

        PRINT "Loading " + filename + "... ";
        LoadFont dir + filename + ".CHR"

        IF i > 1 THEN
            PRINT : PRINT "This font: " + currFont;
            PRINT "    Next font: " + filename;
            PRINT "    Press any key...";
            DO: LOOP WHILE INKEY$ = ""
        END IF

        currFont = filename
        CLS
        PRINT "This font: " + currFont + "    ";

        DisplayTable 0, 0
        scale = 1
        DisplayTable 320, 0
    NEXT
END SUB

SUB DisplayString (str AS STRING, x, y) STATIC
    FOR i = 1 TO LEN(str)
        char = ASC(MID$(str, i, 1)) - &H1F
        DisplayChar char, x, y
        x = x + CharWidth(char) + letterSpacing
    NEXT
END SUB

SUB DisplayTable (x, y) STATIC
    xpos = x
    FOR i = 1 TO Font.charCount
        DisplayChar i, xpos, y

        IF i MOD &H10 = 0 THEN
            xpos = x
            y = y + Font.height + lineSpacing
        ELSE
            xpos = xpos + CharWidth(i) + letterSpacing
        END IF
    NEXT
END SUB

FUNCTION GetByte (addr) STATIC
    DIM char AS STRING * 1
    GET #1, addr + 1, char
    GetByte = ASC(char)
END FUNCTION

' Read 16-bit UNsigned short, because INTEGER is 16-bit signed, return 32-bit signed LONG
FUNCTION GetShort& (addr) STATIC
    GetShort = GetByte(addr) + GetByte(addr + 1) * &H100&
END FUNCTION

FUNCTION GetSignedByte (addr) STATIC
    byte = GetByte(addr)
    IF byte >= &H80 THEN byte = byte - &HFF
    GetSignedByte = byte
END FUNCTION

SUB LoadFont (file AS STRING) STATIC
    IF DEBUG THEN PRINT "Input: "; file

    OPEN file FOR BINARY AS #1

    Font.firstChar = GetByte(FIRSTCHARADDR)
    IF DEBUG THEN PRINT "First char: "; Font.firstChar

    Font.charCount = GetShort(CHARCOUNTADDR)
    IF DEBUG THEN PRINT "Char count: "; Font.charCount

    Font.top = GetSignedByte(HEIGHTTOPADDR)
    Font.baseline = GetSignedByte(HEIGHTBASELINEADDR)
    Font.bottom = GetSignedByte(HEIGHTBOTTOMADDR)
    Font.height = Font.top - Font.bottom
    SetScale
    IF DEBUG THEN PRINT "Height: "; Font.top; Font.baseline; Font.bottom; Font.height

    ' Ignore chars < 0x20
    charOffset = &H20 - Font.firstChar
    Font.recordOffset = TABLESADDR + charOffset * 2
    Font.widthAddr = TABLESADDR + Font.charCount * 2 + charOffset
    Font.vectorTableAddr = TABLESADDR + Font.charCount * 3
    IF DEBUG THEN PRINT "Table addr: "; Font.recordOffset; Font.widthAddr; Font.vectorTableAddr

    Font.charCount = Font.charCount - charOffset
    Font.firstChar = &H20

    REDIM CharWidth(Font.charCount)
    REDIM CharStart(Font.charCount) ' Start of stroke data
    REDIM CharStop(Font.charCount) ' End of stroke data

    ' Calculate vector record count, 2 bytes per record
    Font.recordCount = (LOF(1) - Font.vectorTableAddr) \ 2
    IF DEBUG THEN PRINT "Records: "; Font.recordCount; "-"; Font.charCount; "=";

    ' OPEND records will not be stored, 1 per character
    Font.recordCount = Font.recordCount - Font.charCount
    IF DEBUG THEN PRINT Font.recordCount

    REDIM VectorData(Font.recordCount) AS VectorRecord
    CharStart(1) = 1
    vector = 0

    FOR char = 1 TO Font.charCount
        recordAddr = Font.vectorTableAddr + GetShort(Font.recordOffset)
        remaining = LOF(1) - recordAddr

        IF remaining <= 0 THEN
            PRINT "Invalid data offset in "; file
            END
        END IF

        IF DEBUG >= 2 THEN
            PRINT "ASCII: "; HEX$(Font.firstChar + char - 1); ", Width: "; CharWidth(char)
            PRINT "Record addr: "; recordAddr; remaining
        END IF

        CharWidth(char) = GetSignedByte(Font.widthAddr)
        ProcessVectorData recordAddr, remaining, char, vector

        Font.recordOffset = Font.recordOffset + 2
        Font.widthAddr = Font.widthAddr + 1
    NEXT
    IF DEBUG THEN PRINT "Vector counter: "; vector

    CLOSE #1
END SUB

SUB Preview (nr) STATIC
    IF nr = 1 THEN
        SetFont "TRIP", 200
        DisplayString "Hello", 0, 0
        DisplayString "World!", 0, fontSize / scale + lineSpacing
    ELSEIF nr = 2 THEN
        ' SetFont "LITT", 0
        SetFont "TRIP", 0
        ' SetFont "MODN", 0
        ' SetFont "SANS", 0
        ' SetFont "GOTH", 0
        ' SetFont "BOLD", 0
        DisplayTable 0, 0
        letterSpacing = 0: lineSpacing = 2
        DisplayTable 320 / scale, 0
    ELSEIF nr = 3 THEN
        DisplayFonts
    END IF
END SUB

' Load vector data and character start and stop positions
SUB ProcessVectorData (recordAddr, remaining, char, vector) STATIC
    DIM record AS LONG, op AS LONG

    DO
        IF remaining < 2 THEN
            PRINT "End of file while parsing character definitions"
            END
        END IF

        ' Record contains two op bits and two 7-bit coordinates
        record = GetShort(recordAddr)

        ' Mask coordinates, first bits contain operation
        op = record AND &H8080

        ' Mask op bits, first byte contains y coordinate, second byte contains x coordinate
        x = record AND &H7F
        y = (record AND &H7F00) \ &H100

        ' 7-bit signed
        IF x >= &H40 THEN x = x - &H80
        IF y >= &H40 THEN y = y - &H80

        IF DEBUG = 3 THEN PRINT "Vector: "; HEX$(record); " = " + HEX$(op) + " (" + STR$(x) + ", " + STR$(y) + ")"

        SELECT CASE op
            ' Next char starts after stroke end operation
            CASE OPEND
                op = 0
                IF DEBUG >= 4 THEN PRINT "END"

                CharStop(char) = vector - 1
                IF char < Font.charCount THEN CharStart(char + 1) = vector

                EXIT DO

            CASE OPMOVE
                op = 1
                IF DEBUG >= 4 THEN PRINT "MOVE "; x; ", "; y

            CASE OPDRAW
                op = 2
                IF DEBUG >= 4 THEN PRINT "DRAW "; x; ", "; y

            CASE ELSE
                op = 0
                IF DEBUG THEN PRINT "Input file contains invalid opcode 0x8000"

        END SELECT

        IF op THEN
            vector = vector + 1
            VectorData(vector).op = op
            VectorData(vector).x = x
            VectorData(vector).y = y
        END IF

        recordAddr = recordAddr + 2
        remaining = remaining - 2
    LOOP
END SUB

SUB SetFont (fontName AS STRING, size) STATIC
    DIM currentFont AS STRING
    IF currentFont = fontName THEN EXIT SUB

    PRINT "Loading " + fontName + "... ";
    LoadFont dir + fontName + ".CHR"
    SetFontSize size
    CLS

    currentFont = fontName
END SUB

SUB SetFontSize (pixels) STATIC
    fontScale = 0
    fontSize = pixels
    SetScale
END SUB

SUB SetScale STATIC
    IF fontScale THEN
        scale = fontScale
    ELSEIF fontSize THEN
        scale = fontSize / Font.height
    ELSE
        scale = 1
    END IF
END SUB

