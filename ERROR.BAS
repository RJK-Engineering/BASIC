CONST BADFILENAME = 53

ErrorHandler:
   IF ERR = BADFILENAME THEN
      ' get another file name
      PRINT "File "; UCASE$(filename$); " not found."
      INPUT "Enter the file to display: ", filename$
      RESUME
   ELSE
      ' some other error, so print message and abort
      PRINT "Unrecoverable error--"; ERR
      ON ERROR GOTO 0
   END IF

