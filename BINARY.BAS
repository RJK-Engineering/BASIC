OPEN "QB4UTIL.LIB" FOR BINARY AS #1

DIM value AS STRING * 1
position = 1

DO UNTIL EOF(1)
   GET #1, position, value
   IF NOT (EOF(1)) THEN PRINT ASC(value)
   position = position + 1
   IF position > 10 THEN EXIT DO
LOOP

CLOSE #1

