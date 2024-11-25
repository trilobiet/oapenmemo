Attribute VB_Name = "Module1"
Option Explicit

Dim strFileName As String
Dim strFileNameShort As String
Dim strDateTime As String
Dim intRowCount As Integer

Dim objStream As Object
Dim x As Integer
Dim y As Integer
Dim z As Integer
Sub ExportJSON()
Dim x As Integer

ActiveWorkbook.Sheets("Settings").Activate

'First: get the file name
strFileName = Cells(8, 8)
If strFileName = "" Then
    MsgBox "You forgot to add a file name. I'm sorry, but I'm afraid I can't do anything."
    Exit Sub
End If

'the filename - no directory
x = InStrRev(strFileName, "\")
strFileNameShort = Right(strFileName, Len(strFileName) - x)

'OK, now count the number of titles to export
ActiveWorkbook.Sheets("BookData").Activate
'intRowCount = Cells(Rows.Count, 1).End(xlUp).Row
intRowCount = 1001

'When do we live, exactly?
strDateTime = TimeStamp

'We can actually do stuff if the data is there
'start at row 2, and end at the last row with data
If intRowCount > 0 Then
    strFileName = strFileName & "_" & strDateTime & ".json"
    strFileNameShort = strFileNameShort & "_" & strDateTime & ".json"
    Call CreateFile(strFileName, 2, intRowCount)
End If
End Sub
Sub CreateFile(strFileName As String, intFirst As Integer, intLast As Integer)
'create a JSON file
Set objStream = CreateObject("ADODB.Stream")
objStream.Charset = "UTF-8"

objStream.Open
'start - header
objStream.WriteText ("{" & Chr(10))
objStream.WriteText (Chr(34) & "metadata" & Chr(34) & ": {" & Chr(10))
objStream.WriteText (Chr(34) & "title" & Chr(34) & ": " & Chr(34) & "OAPEN Catalog OPDS Feed" & Chr(34) & "," & Chr(10))
objStream.WriteText (Chr(34) & "numberOfItems" & Chr(34) & ": " & CStr(intRowCount - 1) & Chr(10))
objStream.WriteText ("}," & Chr(10))

objStream.WriteText (Chr(34) & "links" & Chr(34) & ": [" & Chr(10))
objStream.WriteText ("{")
objStream.WriteText (Chr(34) & "href" & Chr(34) & ": " & Chr(34) & strFileNameShort & Chr(34) & "," & Chr(10))
objStream.WriteText (Chr(34) & "type" & Chr(34) & ": " & Chr(34) & "application/opds+json" & Chr(34) & "," & Chr(10))
objStream.WriteText (Chr(34) & "rel" & Chr(34) & ": " & Chr(34) & "self" & Chr(34) & Chr(10))
objStream.WriteText ("}" & Chr(10))
objStream.WriteText ("]," & Chr(10))

objStream.WriteText (Chr(34) & "publications" & Chr(34) & ": [{" & Chr(10))

'write the data of the publications into the file
For y = intFirst To intLast
    Call WriteJSON(strFileName, y)
Next

'wrap it up
objStream.WriteText ("}" & Chr(10) & "]" & Chr(10) & "}")

'save and close the JSON file
objStream.SaveToFile strFileName, 2
objStream.Close
End Sub
Sub WriteJSON(strFile As String, intRow As Integer)
Dim strTitle As String
Dim strSubTitle As String
Dim strIdentifier As String
Dim strAuthor As String
Dim strEditor As String
Dim strLanguage As String
Dim strDescription As String
Dim strPublisher As String
Dim strImprint As String
Dim strPublished As String
Dim strSubject As String
Dim strSeries As String
Dim strPages As String

Dim strLink As String
Dim strHANDLE As String
Dim strImage As String
Dim strImageType  As String



'Here we compile the JSON data, based on the data of one row

'The columns:
'Column 1: BITSTREAM Download URL
'Column 2: BITSTREAM ISBN
'Column 3: dccontributorauthor
'Column 4: dccontributoreditor
'Column 5: dcdateissued
'Column 6: dcdescriptionabstract
'Column 7: dcidentifieruri
'Column 8: dclanguage
'Column 9: lang_code
'Column 10: dcrelationispartofseries
'Column 11: dcsubjectclassification
'Column 12: dcsubjectother
'Column 13: dctitle
'Column 14: dctitlealternative
'Column 15: oapenidentifierdoi
'Column 16: oapenimprint
'Column 17: oapenpages
'Column 18: oapenrelationisPublishedBy_publishername
'Column 19: HANDLE
'Column 20: Cover
'Column 21: subject

'Let's get some metadata
strTitle = WrapStuff("title", QScape(Cells(intRow, 13)), True)
strSubTitle = WrapStuff("subtitle", QScape(Cells(intRow, 14)), True)
strIdentifier = WrapStuff("identifier", "urn:isbn:" & Cells(intRow, 2), True)
strAuthor = WrapStuff("author", SplitStuff(Cells(intRow, 3)), True)
strEditor = WrapStuff("editor", SplitStuff(Cells(intRow, 4)), True)
strLanguage = WrapStuff("language", SplitStuff(Cells(intRow, 9)), True)
strDescription = WrapStuff("description", QScape(Cells(intRow, 6)), True)
strPublisher = WrapStuff("publisher", QScape(Cells(intRow, 18)), True)
strImprint = WrapStuff("imprint", QScape(Cells(intRow, 16)), True)
strPublished = WrapStuff("published", Cells(intRow, 5), True)
strSubject = WrapStuff("subject", QScape(Cells(intRow, 21)), True)
If Cells(intRow, 10) <> "" Then
    strSeries = Chr(34) & "belongsTo" & Chr(34) & ": " & "{" & Chr(34) & "series" & Chr(34) & ": " & Chr(34) & QScape(Cells(intRow, 10)) & Chr(34) & "}," & Chr(10)
Else
    strSeries = ""
End If
'always have a value for pages... It's the last one, so we need a comma at the end
If Cells(intRow, 17) = "" Then
    strPages = WrapStuff("numberOfPages", "0", False)
Else
    strPages = WrapStuff("numberOfPages", Cells(intRow, 17), False)
End If

'Righto, let's create a link where the book can be downloaded:
strLink = Chr(34) & "links" & Chr(34) & ": [" & Chr(10) & _
"{" & Chr(34) & "href" & Chr(34) & ": " & Chr(34) & Cells(intRow, 1) & Chr(34) & ", " & Chr(10) _
& Chr(34) & "rel" & Chr(34) & ": " & Chr(34) & "self" & Chr(34) & "," & Chr(10) _
& Chr(34) & "type" & Chr(34) & ": " & Chr(34) & "application/pdf" & Chr(34) & "}," & Chr(10) & _
"{" & Chr(34) & "href" & Chr(34) & ": " & Chr(34) & Cells(intRow, 1) & Chr(34) & ", " & Chr(10) _
& Chr(34) & "rel" & Chr(34) & ": " & Chr(34) & "http://opds-spec.org/acquisition/open-access" & Chr(34) & "," & Chr(10) _
& Chr(34) & "type" & Chr(34) & ": " & Chr(34) & "application/pdf" & Chr(34) & "}" & Chr(10) & _
"]," & Chr(10)


'Hurray! A cover file link!
If LCase(Right(Cells(intRow, 20), 3)) = "jpg" Then
    strImageType = "image/jpeg"
Else
    strImageType = "image/png"
End If

'last image? don't add "}]}{,", but "}]".
If intRow = intRowCount Then
    strImage = Chr(34) & "images" & Chr(34) & ": [" & "{" & Chr(34) & "href" & Chr(34) & ": " & Chr(34) & Cells(intRow, 20) & Chr(34) & "," _
    & Chr(34) & "type" & Chr(34) & ": " & Chr(34) & strImageType & Chr(34) & "}]" & Chr(10)
Else
    strImage = Chr(34) & "images" & Chr(34) & ": [" & "{" & Chr(34) & "href" & Chr(34) & ": " & Chr(34) & Cells(intRow, 20) & Chr(34) & "," _
    & Chr(34) & "type" & Chr(34) & ": " & Chr(34) & strImageType & Chr(34) & "}]}," & Chr(10) & "{"
End If

'wrapper metadata
objStream.WriteText (Chr(34) & "metadata" & Chr(34) & ": {" & Chr(10))
objStream.WriteText (Chr(34) & "@type" & Chr(34) & ": " & Chr(34) & "http://schema.org/EBook" & Chr(34) & "," & Chr(10))
'the book data
objStream.WriteText (strTitle)
objStream.WriteText (strSubTitle)
objStream.WriteText (strIdentifier)
objStream.WriteText (strAuthor)
objStream.WriteText (strEditor)
objStream.WriteText (strLanguage)
objStream.WriteText (strDescription)
objStream.WriteText (strPublisher)
objStream.WriteText (strSubject)
objStream.WriteText (strSeries)
objStream.WriteText (strPages)
'end wrapper metadata
objStream.WriteText ("},") & Chr(10)
'let's add the link
objStream.WriteText (strLink)
'and next... the image
objStream.WriteText (strImage)


End Sub
Function TimeStamp()
'Stolen from https://stackoverflow.com/questions/5457069/excel-macro-how-can-i-get-the-timestamp-in-yyyy-mm-dd-hhmmss-format
Dim iNow
Dim d(1 To 6)
Dim i As Integer


iNow = Now
d(1) = Year(iNow)
d(2) = Month(iNow)
d(3) = Day(iNow)
d(4) = Hour(iNow)
d(5) = Minute(iNow)
d(6) = Second(iNow)

For i = 1 To 6
    If d(i) < 10 Then TimeStamp = TimeStamp & "0"
    TimeStamp = TimeStamp & d(i)
Next i

End Function
Function QScape(strTxt As String)
'escape stuff, including quote characters
    strTxt = Replace(strTxt, "[", "(")
    strTxt = Replace(strTxt, "]", ")")
    strTxt = Replace(strTxt, "\", "\\")
    strTxt = Replace(strTxt, Chr(34), "\" & Chr(34))
    QScape = strTxt
End Function
Function SplitStuff(strStuff As String)
Dim varStuff As Variant
Dim y As Integer

If strStuff = "" Then
    SplitStuff = ""
    Exit Function
End If

strStuff = Replace(strStuff, Chr(34), "\" & Chr(34))
varStuff = Split(strStuff, "||")

If UBound(varStuff) < 1 Then
    SplitStuff = QScape(strStuff)
Else
    For y = 0 To UBound(varStuff)
        If y = 0 Then
            strStuff = "[" & Chr(34) & QScape(CStr(varStuff(y))) & Chr(34)
        Else
            strStuff = strStuff & "," & Chr(34) & QScape(CStr(varStuff(y))) & Chr(34)
        End If
    Next
    SplitStuff = strStuff & "]"
End If
End Function
Function WrapStuff(strHeader, strTxt, bolComma As Boolean)
Dim strComma As String
If strTxt = "" Then
    WrapStuff = ""
    Exit Function
End If
    
If bolComma Then
    strComma = ","
Else
    strComma = ""
End If
    
If InStr(strTxt, "[") > 0 Then
    WrapStuff = Chr(34) & strHeader & Chr(34) & ": " & strTxt & strComma & Chr(10)
Else
    WrapStuff = Chr(34) & strHeader & Chr(34) & ": " & Chr(34) & strTxt & Chr(34) & strComma & Chr(10)
End If
End Function
