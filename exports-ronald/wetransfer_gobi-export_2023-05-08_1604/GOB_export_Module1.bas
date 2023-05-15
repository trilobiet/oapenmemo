Attribute VB_Name = "Module1"
Option Explicit

Dim intRowCount As Integer
Dim intExportCount As Integer
Dim strDirectory As String
Dim strFileName As String
Dim objStream

Dim strMessage As String

Dim strSenderOrg As String
Dim strSenderMail As String
Dim strDateNow As String

Dim varISBN As Variant
Dim varISBNChecklist As Variant
Dim varISBNOther As Variant

Dim c As Integer
Dim d As Integer
Dim p As Integer
Dim q As Integer
Dim r As Integer
Dim s As Integer
Dim x As Integer
Dim y As Integer
Dim z As Integer


Dim intISBNUnique As Integer
Dim intAscW As Integer
Dim intDownloads As Integer


Function MakeFolder(strFolder As String)

If Len(Dir(strFolder, vbDirectory)) = 0 Then
   MkDir strFolder
End If
End Function

Sub ExportToXML()
strDateNow = Year(Now) & Right("0" & Month(Now), 2) & Right("0" & Day(Now), 2)
z = 0

intISBNUnique = 0
intAscW = 0
intDownloads = 0


'directory and file name
strDirectory = ActiveWorkbook.Sheets("Start").Range("F17").Value
If Right(strDirectory, 1) <> "\" Then
    strDirectory = strDirectory & "\"
End If
strFileName = strDirectory & "OAPEN2GOBI_" & strDateNow & "-" & Right("0" & Hour(Now), 2) & Right("0" & Minute(Now), 2) & Right("0" & Second(Now), 2)

strSenderOrg = ActiveWorkbook.Sheets("Start").Range("F19").Value
strSenderMail = ActiveWorkbook.Sheets("Start").Range("F20").Value

ActiveWorkbook.Sheets("BookData").Activate
intRowCount = Cells(Rows.Count, 1).End(xlUp).Row

'counter for the ISBN checklist
c = 0

'OK, let's start, shall we?
Call CreateFile(strFileName & ".xml", 2, intRowCount)   'we start at line 2
'Call CreateFile(strFileName & "_" & CStr(p) & ".xml", 2, 250)  'we start at line 2

'update the message: only count the exported titles!
strMessage = "That's all folks!" & Chr(10) & "You have now exported the data of " & CStr(z) & " title(s) to the file " & strFileName & "."

'MsgBox ("ISBNUnique: " & CStr(intISBNUnique) & Chr(10) _
& "intAscW: " & CStr(intAscW) & Chr(10) _
& "intDownloads: " & CStr(intDownloads) & Chr(10) _
)



MsgBox strMessage, vbInformation, "Export is finished"

End Sub
Sub WriteXML(strFile As String, intRow As Integer)

Dim bolISBNunique As Boolean
Dim strAbstract As String
Dim strAuthor As String
Dim strBIC As String
Dim strBookTitle As String
Dim strChapterTitle As String
Dim strCoverURL As String
Dim strDOI As String
Dim strDownload As String
Dim strEditor As String
Dim strFunder As String
Dim strGrantnumber As String
Dim strHANDLE As String
Dim strImprint As String
Dim strISBN As String
Dim strISBNOther As String
Dim strISBNAll As String
Dim strISBNUnique As String
Dim strJurisdiction As String
Dim strKeyword As String
Dim strLanguage As String
Dim strLicense As String
Dim strNameFirst As String
Dim strNameLast As String
Dim strOther As String
Dim strPages As String
Dim strPlace As String
Dim strProgramname As String
Dim strProjectacronym As String
Dim strProjectname As String
Dim strPublisher As String
Dim strPubType As String
Dim strSubTitle As String
Dim strSeriesISSN As String
Dim strSeriesNumber As String
Dim strSeriesTitle As String
Dim strWebshop As String
Dim strYear As String
Dim varAuthor As Variant
Dim varBic As Variant
Dim varDownload As Variant
Dim varEditor As Variant
Dim varFunder As Variant
Dim varGrantnumber As Variant
Dim varJurisdiction As Variant
Dim varKeyword As Variant
Dim varLanguage As Variant
Dim varORCID As Variant
Dim varProgramname As Variant
Dim varProjectacronym As Variant
Dim varProjectname As Variant




'Columns:
'EAN/ISBN: column 4,19,56,72
'Title: column: 31
'SubTitle: column 32
'Publication_Date: column 13
'Series_Title: coulumn 25
'Volume_Number: coulum 75
'Imprint: column 70
'Pages: column 59
'Product_ID: column 21
'Language_Code: column 23
'URL: column 3
'Contributor/Author: column 8
'Contributor/Editor: column 9

'since January 2023: other columns in the CSV export!!

'new columns:
'EAN/ISBN: column 4,20,57,74 !!
'Title: column: 32 !!
'SubTitle: column 34 !!
'Publication_Date: column 14 !!
'Series_Title: coulumn 26 !!
'Volume_Number: coulum 77 !!
'Imprint: column 72 !!
'Pages: column 61 !!
'Product_ID: column 22 !!
'Language_Code: column 24 !!
'URL: column 3
'Contributor/Author: column 8
'Contributor/Editor: column 9

'Put the values in variables, change where needed
'strPubType = Cells(intRow, 33)
strPubType = Cells(intRow, 34) 'new column

strDownload = Cells(intRow, 3)
'multiple URLS? we only need the first one
If InStr(strDownload, "||") > 0 Then
    varDownload = Split(strDownload, "||")
    strDownload = varDownload(0)
    varDownload = Empty
End If

'strBookTitle = TidyText(Cells(intRow, 31))
strBookTitle = TidyText(Cells(intRow, 32))

strISBN = ""
strISBNAll = ""
strISBNUnique = ""
strISBNOther = ""

If Cells(intRow, 4) <> "" Then
    strISBNAll = Cells(intRow, 4)
End If

'If Cells(intRow, 19) <> "" Then
'    If strISBNAll = "" Then
'        strISBNAll = Cells(intRow, 19)
'    Else
'        strISBNAll = strISBNAll & "||" & Cells(intRow, 19)
'    End If
'End If

If Cells(intRow, 20) <> "" Then
    If strISBNAll = "" Then
        strISBNAll = Cells(intRow, 20)
    Else
        strISBNAll = strISBNAll & "||" & Cells(intRow, 20)
    End If
End If


'If Cells(intRow, 56) <> "" Then
'    If strISBNAll = "" Then
'        strISBNAll = Cells(intRow, 56)
'    Else
'        strISBNAll = strISBNAll & "||" & Cells(intRow, 56)
'    End If
'End If

If Cells(intRow, 57) <> "" Then
    If strISBNAll = "" Then
        strISBNAll = Cells(intRow, 57)
    Else
        strISBNAll = strISBNAll & "||" & Cells(intRow, 57)
    End If
End If

'If Cells(intRow, 72) <> "" Then
'    If strISBNAll = "" Then
'        strISBNAll = Cells(intRow, 72)
'    Else
'        strISBNAll = strISBNAll & "||" & Cells(intRow, 72)
'    End If
'End If

If Cells(intRow, 74) <> "" Then
    If strISBNAll = "" Then
        strISBNAll = Cells(intRow, 74)
    Else
        strISBNAll = strISBNAll & "||" & Cells(intRow, 74)
    End If
End If

strISBNAll = Replace(strISBNAll, "-", "")
strISBNAll = Replace(strISBNAll, "X", "")
strISBNAll = Replace(strISBNAll, "x", "")
strISBNAll = Replace(strISBNAll, ";", "||")

If strISBNAll = "" Then

Else

If Len(Split(strISBNAll, "||")(0)) < 13 Then

Else

strISBNUnique = getUniqueValues(Split(strISBNAll, "||"))
varISBN = Split(strISBNUnique, "||")

'Stop
q = 0
p = 0
If UBound(varISBN) > -1 Then
    'We only want ISBNs that are exactly 13 characters long and don't contain dashes or x'es
    For p = 0 To UBound(varISBN)
        If Len(varISBN(p)) = 13 Then
            If InStr(LCase(varISBN(p)), "xxx") = 0 And InStr(varISBN(p), "-") = 0 Then
                strISBN = varISBN(p)
                Exit For
            End If
        End If
    Next
Else
    strISBN = ""
End If

'Stop
If p + 1 <= UBound(varISBN) Then
    If Len(varISBN(p + 1)) = 13 Then
            strISBNOther = varISBN(p + 1)
    End If
Else
    strISBNOther = ""
End If

If strISBN = "" Then
'No empty ISBNs

Else

bolISBNunique = True

'check for existing ISBNs
If c = 0 Then
    'this is the first one...
    ReDim varISBNChecklist(0)
    varISBNChecklist(0) = strISBN
Else
    For d = 0 To UBound(varISBNChecklist)
        If strISBN = varISBNChecklist(d) Then
            bolISBNunique = False
            Exit For
        End If
    Next
End If
If bolISBNunique Then
    c = c + 1
    ReDim Preserve varISBNChecklist(c)
    varISBNChecklist(c) = strISBN
End If


    
If bolISBNunique = False Then
    intISBNUnique = intISBNUnique + 1
Else

If AscW(strBookTitle) > 384 Then
'skip records that have non-roman characters in the titles
    intAscW = intAscW + 1
    
Else
If strDownload = "" Then
'skip records without download URL
    intDownloads = intDownloads + 1

Else
If InStr(LCase(strPubType), "chap") = 0 Then
'We don't want to add chapters

z = z + 1
'strSubTitle = TidyText(Cells(intRow, 32))
'strAuthor = Cells(intRow, 8)
'varAuthor = Split(strAuthor, "||")
'strEditor = Cells(intRow, 9)
'varEditor = Split(strEditor, "||")
'strPublisher = TidyText(Cells(intRow, 70))
'strYear = Left(Cells(intRow, 11), 4)
'strHANDLE = Cells(intRow, 21)

strSubTitle = TidyText(Cells(intRow, 33))
strAuthor = Cells(intRow, 8)
varAuthor = Split(strAuthor, "||")
strEditor = Cells(intRow, 9)
varEditor = Split(strEditor, "||")
strPublisher = TidyText(Cells(intRow, 72))
strYear = Left(Cells(intRow, 14), 4)
strHANDLE = Cells(intRow, 22)

strHANDLE = Replace(strHANDLE, "https://library.oapen.org/handle/", "")
strHANDLE = Replace(strHANDLE, "http://library.oapen.org/handle/", "")

'strPublisher = TidyText(StripAccent(Cells(intRow, 70)))
'strSeriesTitle = TidyText(StripAccent(Cells(intRow, 25)))
'strSeriesNumber = Cells(intRow, 75)
'strLanguage = Cells(intRow, 23)
'strLanguage = Replace(strLanguage, " ", "")
'varLanguage = Split(strLanguage, "||")
'strPages = Cells(intRow, 59)

strPublisher = TidyText(StripAccent(Cells(intRow, 72)))
strSeriesTitle = TidyText(StripAccent(Cells(intRow, 26)))
strSeriesNumber = Cells(intRow, 77)
strLanguage = Cells(intRow, 24)
strLanguage = Replace(strLanguage, " ", "")
varLanguage = Split(strLanguage, "||")
strPages = Cells(intRow, 61)

'first block: eBook/bibData
objStream.WriteText ("<eBook>" & Chr(10))
objStream.WriteText ("<bibData>" & Chr(10))
'ISBN (first)
If strISBN <> "" Then
    objStream.WriteText ("<EAN>")
    objStream.WriteText (strISBN)
    objStream.WriteText ("</EAN>" & Chr(10))
Else
    objStream.WriteText ("<EAN></EAN>" & Chr(10))
End If
'Second ISBN
If strISBNOther <> "" Then
    objStream.WriteText ("<Physical_EAN>")
    objStream.WriteText (strISBNOther)
    objStream.WriteText ("</Physical_EAN>" & Chr(10))
Else
    objStream.WriteText ("<Physical_EAN></Physical_EAN>" & Chr(10))
End If
'title
objStream.WriteText ("<Title>")
objStream.WriteText (StripAccent(strBookTitle))
objStream.WriteText ("</Title>" & Chr(10))
'subtitle
objStream.WriteText ("<SubTitle>")
objStream.WriteText (StripAccent(strSubTitle))
objStream.WriteText ("</SubTitle>" & Chr(10))
'Pricing
objStream.WriteText ("<pricing_method>STD</pricing_method>" & Chr(10))
'Vendor_name
objStream.WriteText ("<Vendor_Name>OAPEN</Vendor_Name>" & Chr(10))
'publication date
objStream.WriteText ("<Publication_Date>")
objStream.WriteText (strYear)
objStream.WriteText ("</Publication_Date>" & Chr(10))
'Series_title, Volume_Number
objStream.WriteText ("<Series_Title>")
objStream.WriteText (strSeriesTitle)
objStream.WriteText ("</Series_Title>" & Chr(10))
objStream.WriteText ("<Volume_Number>")
objStream.WriteText (strSeriesNumber)
objStream.WriteText ("</Volume_Number>" & Chr(10))
'Imprint = publisher
objStream.WriteText ("<Imprint>")
objStream.WriteText (strPublisher)
objStream.WriteText ("</Imprint>" & Chr(10))
'physical format
objStream.WriteText ("<Physical_Format>eBook</Physical_Format>" & Chr(10))
'Pages
objStream.WriteText ("<Pages>")
objStream.WriteText (strPages)
objStream.WriteText ("</Pages>" & Chr(10))
'LC Class
objStream.WriteText ("<LC_Class></LC_Class>" & Chr(10))
'Adult_juvenile
objStream.WriteText ("<Adult_Juvenile>A</Adult_Juvenile>" & Chr(10))
'Product_ID
objStream.WriteText ("<Product_ID>")
objStream.WriteText (strHANDLE)
objStream.WriteText ("</Product_ID>" & Chr(10))
'Language
'For p = 0 To UBound(varLanguage)
'    objStream.WriteText ("<Language_Code>")
'    objStream.WriteText (Left(Right(varLanguage(p), 4), 3))
'    objStream.WriteText ("</Language_Code>" & Chr(10))
'Next
'just write the first language
If UBound(varLanguage) > -1 Then
    objStream.WriteText ("<Language_Code>")
    objStream.WriteText (Left(Right(varLanguage(0), 4), 3))
    objStream.WriteText ("</Language_Code>" & Chr(10))
End If

'Sales_rights
objStream.WriteText ("<Sales_Rights_Group>OAPEN_OPEN_ACCESS</Sales_Rights_Group>" & Chr(10))
'Download
objStream.WriteText ("<URL>")
objStream.WriteText (strDownload)
objStream.WriteText ("</URL>" & Chr(10))

'End of bibData block
objStream.WriteText ("</bibData>" & Chr(10))

'Contributor block

'Authors
If strAuthor <> "" Then
    For p = 0 To UBound(varAuthor)
        objStream.WriteText ("<Contributor>" & Chr(10))
        objStream.WriteText ("<Name>")
        'No ORCIDs please
        If InStr(varAuthor(p), "::") > 0 Then
            varORCID = Split(varAuthor(p), "::")
            objStream.WriteText StripAccent(TidyText(varORCID(0)))
        Else
            objStream.WriteText StripAccent(TidyText(varAuthor(p)))
        End If
        objStream.WriteText ("</Name>" & Chr(10))
        objStream.WriteText ("<Role>Author</Role>" & Chr(10))
        objStream.WriteText ("</Contributor>" & Chr(10))
    Next
End If
'Editors
If strEditor <> "" Then
    For p = 0 To UBound(varEditor)
        objStream.WriteText ("<Contributor>" & Chr(10))
        objStream.WriteText ("<Name>")
        'No ORCIDs please
        If InStr(varEditor(p), "::") > 0 Then
            varORCID = Split(varEditor(p), "::")
            objStream.WriteText StripAccent(TidyText(varORCID(0)))
        Else
            objStream.WriteText StripAccent(TidyText(varEditor(p)))
        End If
        objStream.WriteText ("</Name>" & Chr(10))
        objStream.WriteText ("<Role>Editor</Role>" & Chr(10))
        objStream.WriteText ("</Contributor>" & Chr(10))
    Next
End If

'End of Contributor block


'BISAC block
'objStream.WriteText ("<BISAC>" & Chr(10))
'objStream.WriteText ("<Literal></Literal>" & Chr(10))
'objStream.WriteText ("</BISAC>" & Chr(10))

'Product block
objStream.WriteText ("<Product>" & Chr(10))
'Type
objStream.WriteText ("<Type>UU</Type>" & Chr(10))

'Currency block
objStream.WriteText ("<Currency>" & Chr(10))
'Code, list price, discount percent, discount amount
objStream.WriteText ("<Currency_Code>USD</Currency_Code>" & Chr(10))
objStream.WriteText ("<List_Price>0.00</List_Price>" & Chr(10))
objStream.WriteText ("<Discount_Percent>0</Discount_Percent>" & Chr(10))
objStream.WriteText ("<Discount_amount>0.00</Discount_amount>" & Chr(10))
'End of Currency block
objStream.WriteText ("</Currency>" & Chr(10))

'Consortia
objStream.WriteText ("<Available_To_Consortia>Y</Available_To_Consortia>" & Chr(10))

'Downloadable
objStream.WriteText ("<Downloadable>Y</Downloadable>" & Chr(10))

'DDA
objStream.WriteText ("<DDA_Available>N</DDA_Available>" & Chr(10))

'STL
objStream.WriteText ("<STL_Available>N</STL_Available>" & Chr(10))

'Status
objStream.WriteText ("<Status>OA</Status>" & Chr(10))

'End of Product block
objStream.WriteText ("</Product>" & Chr(10))

'end of block, end of description
objStream.WriteText ("</eBook>" & Chr(10))

'!!! end of the check for chapter
End If
'!!! end of the check for ISBN
End If
'!!! end of the check for download URL
End If
'end of the check on non-roman characters

End If
End If
End If
End If



End Sub
Sub ContributorData(varContributor As Variant, strType As String)
Dim varContrib As Variant
Dim varFirstLast As Variant
Dim strContribName As String
Dim strFirstName As String
Dim strLastName As String
Dim varName As Variant
Dim strORCID As String
Dim A

'check for empty values
If IsEmpty(varContributor) Then Exit Sub

For x = 0 To UBound(varContributor)
    'no empty values please
    If Len(Trim(varContributor(x))) > 0 Then
    'OK, let's go!
        'First: get the ORCID
        If InStr(varContributor(x), "(") > 0 Then
            varContrib = Split(varContributor(x), "(")
            strORCID = varContrib(1)
            strORCID = Replace(strORCID, ")", "")
            strContribName = varContrib(0)
        Else
            strContribName = varContributor(x)
        End If
        
        'Second: see if first and last name are separated by a comma
        If InStr(strContribName, ",") = 0 Then
            varFirstLast = Split(Trim(strContribName), " ")
            'value not empty?
            If UBound(varFirstLast) > 0 Then
                strFirstName = varFirstLast(0)
                For A = 1 To UBound(varFirstLast)
                    'what to do with John M. Doe?
                    If Right(varFirstLast(A), 1) = "." Then
                        strFirstName = Trim(strFirstName & " " & varFirstLast(A))
                    Else
                        strLastName = Trim(strLastName & " " & varFirstLast(A))
                    End If
                Next
            End If
            'empty first name?
            If strFirstName = "" Then
                strContribName = strLastName & ", [None]"
            Else
                strContribName = strLastName & ", " & strFirstName
            End If
        End If
        
        varName = Split(TidyText(strContribName), ",")
        
        
        objStream.WriteText ("<Contributor>" & Chr(10))
        objStream.WriteText ("<SequenceNumber>")
        objStream.WriteText (CStr(x + 1))
        objStream.WriteText ("</SequenceNumber>" & Chr(10))
        objStream.WriteText ("<ContributorRole>" & strType & "</ContributorRole>" & Chr(10))
        If strORCID <> "" Then
            objStream.WriteText ("<NameIdentifier>" & Chr(10))
            objStream.WriteText ("<NameIDType>21</NameIDType>" & Chr(10))
            objStream.WriteText ("<IDValue>")
            objStream.WriteText (Trim(strORCID))
            objStream.WriteText ("</IDValue>" & Chr(10))
            objStream.WriteText ("</NameIdentifier>" & Chr(10))
        End If
        If UBound(varName) > 0 Then
            'another check: no empty first names
            Select Case Trim(varName(1))
                Case "[None]"
                Case ""
                Case Else
                    objStream.WriteText ("<NamesBeforeKey>")
                    objStream.WriteText (Trim(varName(1)))
                    objStream.WriteText ("</NamesBeforeKey>" & Chr(10))
            End Select
        End If
        objStream.WriteText ("<KeyNames>")
        objStream.WriteText (Trim(varName(0)))
        objStream.WriteText ("</KeyNames>" & Chr(10))
        objStream.WriteText ("</Contributor>" & Chr(10))
    End If
    
    'clean up
    varContrib = ""
    varFirstLast = ""
    strContribName = ""
    strFirstName = ""
    strLastName = ""
    varName = ""
    strORCID = ""
Next
End Sub
Function TidyText(strTXT) As String
strTXT = Replace(strTXT, Chr(9), " ")
strTXT = Replace(strTXT, Chr(10), " ")
strTXT = Replace(strTXT, Chr(13), " ")
strTXT = Replace(strTXT, "&", "&amp;")
strTXT = Replace(strTXT, "&amp;amp;", "&amp;")
strTXT = Replace(strTXT, "<", "&lt;")
strTXT = Replace(strTXT, ">", "&gt;")
strTXT = Replace(strTXT, Chr(34), "&quot;")
strTXT = Replace(strTXT, "'", "&apos;")
strTXT = Replace(strTXT, "‘", "&apos;")

TidyText = Trim(strTXT)
End Function
Sub CreateFile(strFileName As String, intFirst As Integer, intLast As Integer)
'create a XML file
Set objStream = CreateObject("ADODB.Stream")
objStream.Charset = "UTF-8"

objStream.Open
'start - header
objStream.WriteText ("<?xml version='1.0' encoding='UTF-8'?>" & Chr(10))
objStream.WriteText ("<eBooks>" & Chr(10))
objStream.WriteText ("<header>" & Chr(10))
objStream.WriteText ("<Loader_ID>OAPEN</Loader_ID>" & Chr(10))
objStream.WriteText ("</header>" & Chr(10))

'write the data of the publications into the file
For y = intFirst To intLast
    Call WriteXML(strFileName, y)
Next

'wrap it up
objStream.WriteText ("</eBooks>" & Chr(10))

'save and close the XML file
objStream.SaveToFile strFileName, 2
objStream.Close
End Sub
Function HtmlDecode(str)
'See https://stackoverflow.com/questions/53268605/decode-html-entities-into-plain-text
'the code removes the HTML encoding, and just leaves the plain text
    Dim dom

    Set dom = CreateObject("htmlfile")
    dom.Open
    dom.Write str
    dom.Close
    HtmlDecode = dom.body.innerText
End Function
Function getUniqueValues(varInput As Variant) As String
Dim list As New Collection
Dim strResult As String
Dim arrInput As Variant
Dim Value
Dim i As Integer

If UBound(varInput) < 0 Then Exit Function

arrInput = varInput

'Adding each value of arrInput to the collection.
On Error Resume Next
For Each Value In arrInput
    'here value and key are the same. The collection does not allow duplicate keys hence only unique values will remain.
    list.Add Trim(CStr(Value)), Trim(CStr(Value))
Next
On Error GoTo 0

'Adding unique value to the result
For i = 0 To list.Count - 1
    strResult = strResult & "||" & list(i + 1)
Next

'Printing the array
getUniqueValues = Right(strResult, Len(strResult) - 2)
End Function
Function StripAccent(thestring As String)
Dim A As String * 1
Dim B As String * 1
Dim i As Integer
Const AccChars = "ŠŽšžŸÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖÙÚÛÜÝàáâãäåçèéêëìíîïðñòóôõöùúûüýÿ"
Const RegChars = "SZszYAAAAAACEEEEIIIIDNOOOOOUUUUYaaaaaaceeeeiiiidnooooouuuuyy"
For i = 1 To Len(AccChars)
A = Mid(AccChars, i, 1)
B = Mid(RegChars, i, 1)
thestring = Replace(thestring, A, B)
Next
StripAccent = thestring
End Function


