' 80h     '+'  flags stroke file type
' 81h-82h  number chars in font file (n)
' 83h      undefined
' 84h      ASCII value of first char in file
' 85h-86h  offset to stroke definitions (8+3n)
' 87h      scan flag (normally 0)
' 88h      distance from origin to top of capital
' 89h      distance from origin to baseline
' 8Ah      distance from origin to bottom descender
' 8Bh-8Fh  undefined
' 90h      offsets to individual character definitions
' 90h+2n   width table (one word per character)
' 90h+3n   start of character definitions
TYPE DataPositions
  Header AS INTEGER
  HeaderSize AS INTEGER
  Title AS INTEGER
  FontData AS INTEGER

  PlusSign AS INTEGER
  NumberOfChars AS INTEGER
  FirstCharAsciiValue AS INTEGER
  OffsetToStrokeDefs AS INTEGER
  ScanFlag AS INTEGER
  DistanceFromOriginToTopOfCapital AS INTEGER
  DistanceFromOriginToBaseline AS INTEGER
  DistanceFromOriginToBottomDescender AS INTEGER
  OffsetsToCharacterDefinitions AS INTEGER
END TYPE

TYPE FontFile
  HeaderSize AS INTEGER
  Title AS STRING * 4
END TYPE

DIM P AS DataPositions
DIM F AS FontFile

DATA &h0,&h5a,&h5c,&H80
READ P.Header, P.HeaderSize, P.Title, P.FontData

DATA &h0,&h1,&h4,&h5,&h7,&h8,&h9,&hA,&h10
READ P.PlusSign, P.NumberOfChars, P.FirstCharAsciiValue, P.OffsetToStrokeDefs
READ P.ScanFlag, P.DistanceFromOriginToTopOfCapital, P.DistanceFromOriginToBaseline
READ P.DistanceFromOriginToBottomDescender, P.OffsetsToCharacterDefinitions

'OPEN "C:\QUIKMENU\LITT.CHR" FOR BINARY AS #1
OPEN "C:\QUIKMENU\MODN.CHR" FOR BINARY AS #1

DIM b AS STRING * 1
GET #1, P.Title - 3, B
IF ASC(B) <> &H1A THEN
    P.HeaderSize = P.HeaderSize + 1
    P.Title = P.Title + 1

    GET #1, P.Title - 3, B
    IF ASC(B) <> &H1A THEN
        PRINT "Invalid file format"
        GOTO Bye
    END IF
END IF

GET #1, P.Title, F.Title
PRINT "Title: "; F.Title

GET #1, P.HeaderSize, F.HeaderSize
PRINT "HeaderSize: "; F.HeaderSize

GET #1, F.HeaderSize + P.PlusSign + 1, B
PRINT ": "; B


Bye:
CLOSE #1
