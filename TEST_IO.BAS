TYPE TestRecord
'  Student AS STRING * 18
  Score AS SINGLE
END TYPE
DIM MyClass AS TestRecord

OPEN "FINAL.DAT" FOR RANDOM AS #1 LEN = LEN(MyClass)

'MyClass.Student = "MarySa-1"
MyClass.Score = 1
PUT #1, 1, MyClass

'MyClass.Student = "MarySa0"
MyClass.Score = 2
PUT #1, 2, MyClass

'MyClass.Student = "MarySa1"
MyClass.Score = 3
PUT #1, 3, MyClass

CLOSE #1

OPEN "FINAL.DAT" FOR RANDOM AS #1 LEN = LEN(MyClass)
GET #1, 1, MyClass
'PRINT "STUDENT:", MyClass.Student
PRINT "SCORE:", MyClass.Score
CLOSE #1
'KILL "FINAL.DAT"

