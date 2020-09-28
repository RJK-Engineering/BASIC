DECLARE SUB PrintFile (file AS ANY)
fDEFINT A - Z

TYPE FileRecord
    filename AS STRING * 12
    basename AS STRING * 8
    extension AS STRING * 3
    size AS LONG
    date AS STRING * 10
    time AS STRING * 5
END TYPE

DIM file AS FileRecord

tmpFile$ = "~TMP.~~~"
spec$ = "*.BAS"

IF bare THEN
    SHELL ENVIRON$("COMSPEC") + "/C DIR /B " + spec$ + ">" + tmpFile$
ELSE
    SHELL ENVIRON$("COMSPEC") + "/C DIR " + spec$ + ">" + tmpFile$
END IF

OPEN tmpFile$ FOR INPUT AS 1

lines = 0
DO WHILE NOT EOF(1)
    LINE INPUT #1, line$
    lines = lines + 1
    ' print line$
    file.basename = MID$(line$, 1, 5)
    file.extension = MID$(line$, 10, 3)
    file.filename = RTRIM$(file.basename) + "." + RTRIM$(file.extension)
    file.size = VAL(MID$(line$, 14, 2) + MID$(line$, 17, 3) + MID$(line$, 21, 3) + MID$(line$, 25, 3) + MID$(line$, 29, 3))
    file.date = MID$(line$, 33, 10)
    file.time = MID$(line$, 44, 5)
    PrintFile file
LOOP

CLOSE #1

KILL tmpFile$
END

DEFINT A-Z
SUB PrintFile (file AS FileRecord) STATIC
    PRINT file.filename, file.size, file.date, file.time
END SUB

