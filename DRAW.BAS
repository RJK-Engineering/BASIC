DECLARE SUB Palette256 ()
RANDOMIZE TIMER
SCREEN 13

'RndPixelColors256
Palette256
'Pause

SUB Palette256
    FOR y = 0 TO 15
        FOR x = 0 TO 15
            'PSET (x, y), y * 16 + x
            LINE (8 * x, 8 * y)-(8 * x + 8, 8 * y + 8), y * 16 + x, BF
        NEXT x
    NEXT y
END SUB

SUB Pause
    DO
    LOOP UNTIL INKEY$ <> ""
END SUB

SUB RndPixelColors256
    FOR x = 0 TO 319
        FOR y = 0 TO 199
            PSET (x, y), RND * 256
        NEXT y
    NEXT x
END SUB

