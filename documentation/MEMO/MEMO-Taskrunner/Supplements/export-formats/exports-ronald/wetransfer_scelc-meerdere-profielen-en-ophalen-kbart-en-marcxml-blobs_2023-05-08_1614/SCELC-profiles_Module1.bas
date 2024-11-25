Attribute VB_Name = "Module1"
Option Explicit
Sub GetDataFromJSON_old_remove(strWSName As String, strDirectory As String, strProfileName As String)
Dim xmlHttp As Object
Dim xmlHttp2 As Object
Dim strReturn As String
Dim strURL As String
Dim varSplit As Variant
Dim intStart As Integer
Dim intEnd As Integer
Dim intRowCount As Integer
Dim strRetrieveLink As String
Dim x As Integer, y As Integer
Dim objFSKBART As Object
Dim objKBARTFile As Object
Dim objFSMARC As Object
Dim objStream As Object
Dim strHANDLE As String
Dim strDocID As String
Dim strFileName As String

On Error Resume Next


ActiveWorkbook.Sheets(strWSName).Activate
intRowCount = Cells(Rows.Count, 1).End(xlUp).Row


    'Set objFS = CreateObject("ADODB.Stream")
    'objFS.Charset = "utf-8"
    'objFS.Open
    'objFS.WriteText sFileData
    'objFS.SaveToFile sOutFilePath, 2   '2: Create Or Update
    'objFS.Close

'Create a FileSystemObject to gather all the KBART texts
Set objFSKBART = CreateObject("Scripting.FileSystemObject")
'Create a textfile to store the results
Set objKBARTFile = objFSKBART.CreateTextFile(strDirectory & strProfileName & "OAPEN_KBART.tsv")

'header KBART file
objKBARTFile.Writeline "publication_title" & Chr(9) & "print_identifier" & Chr(9) & "online_identifier" & Chr(9) & "date_first_issue_online" & _
Chr(9) & "num_first_vol_online" & Chr(9) & "num_first_issue_online" & Chr(9) & "date_last_issue_online" & Chr(9) & "num_last_vol_online" & _
Chr(9) & "num_last_issue_online" & Chr(9) & "title_url" & Chr(9) & "first_author" & Chr(9) & "title_id" & Chr(9) & "embargo_info" & _
Chr(9) & "coverage_depth" & Chr(9) & "notes" & Chr(9) & "publisher_name" & Chr(9) & "publication_type" & Chr(9) & "date_monograph_published_print" & _
Chr(9) & "date_monograph_published_online" & Chr(9) & "monograph_volume" & Chr(9) & "monograph_edition" & Chr(9) & "first_editor" & _
Chr(9) & "parent_publication_title_id" & Chr(9) & "preceding_publication_title_id" & Chr(9) & "access_type" & Chr(9) & "OCLC_Control_Number"


'Create a FileSystemObject to gather all the MARCXML XML data
Set objFSMARC = CreateObject("Scripting.FileSystemObject")
'Here we create a stream object, and set the encoding to UTF-8
Set objStream = CreateObject("ADODB.Stream")
objStream.Charset = "UTF-8"
objStream.Open

strFileName = strDirectory & strProfileName & "OAPEN_MARC.xml"
'header MARCXML file
objStream.writetext "<?xml version=" & Chr(34) & "1.0" & Chr(34) & " encoding=" & Chr(34) & "UTF-8" & _
Chr(34) & "?><marc:collection xmlns:marc=" & Chr(34) & "http://www.loc.gov/MARC21/slim" & Chr(34) & ">" & Chr(10)


For y = 2 To intRowCount
'For y = 2 To 15
'Start with line 2
    strDocID = Cells(y, 1)
    strHANDLE = Cells(y, 21)
    strHANDLE = Replace(strHANDLE, "http://library.oapen.org/handle/", "")
    strHANDLE = Replace(strHANDLE, "https://library.oapen.org/handle/", "")
     
    strURL = "https://library.oapen.org/rest/search?query=handle:%22" & strHANDLE & "%22&expand=metadata,bitstreams"
     

    'Open URL and get JSON data
    Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    xmlHttp.Open "GET", strURL
    xmlHttp.setRequestHeader "Content-Type", "text/xml"
    xmlHttp.send
  
    'Save the response to a string
    strReturn = xmlHttp.responsetext

    'Split the JSON using the string "uuid": - all the bitstreams have a uuid
    varSplit = Split(strReturn, """uuid"":")
    For x = 1 To UBound(varSplit)
        'Get the MARCXML data, and write it to a separate file
        If InStr(varSplit(x), "marc.xml") Then
        'get the retrievelink for the MARCXML
            intStart = InStr(varSplit(x), """retrieveLink"":")
            intEnd = InStr(intStart, varSplit(x), ",")
            strRetrieveLink = Mid(varSplit(x), intStart, intEnd - intStart)
            strRetrieveLink = "https://library.oapen.org" & Replace(Replace(strRetrieveLink, """retrieveLink"":", ""), Chr(34), "")
            'Get the MARCXML and add it to the file
            Set xmlHttp2 = CreateObject("MSXML2.ServerXMLHTTP.6.0")
            xmlHttp2.Open "GET", strRetrieveLink
            xmlHttp2.setRequestHeader "Content-Type", "text/xml"
            xmlHttp2.send
            objStream.writetext Replace(Replace(xmlHttp2.responsetext, Chr(10), " "), Chr(13), " ") & Chr(10)
        End If
        
        'Get the KBART text and add it to a file
        If InStr(varSplit(x), ".tsv") Then
        'get the retrievelink for the KBART text
            intStart = InStr(varSplit(x), """retrieveLink"":")
            intEnd = InStr(intStart, varSplit(x), ",")
            strRetrieveLink = Mid(varSplit(x), intStart, intEnd - intStart)
            strRetrieveLink = "https://library.oapen.org" & Replace(Replace(strRetrieveLink, """retrieveLink"":", ""), Chr(34), "")
            'Get the KBART text and add it to the file
            Set xmlHttp2 = CreateObject("MSXML2.ServerXMLHTTP.6.0")
            xmlHttp2.Open "GET", strRetrieveLink
            xmlHttp2.setRequestHeader "Content-Type", "text/xml"
            xmlHttp2.send
            Dim strResponseText As String
            strResponseText = xmlHttp2.responsetext
            'MsgBox strResponseText
            objKBARTFile.Writeline strResponseText
        End If
    Next
'end of the loop
Next
'OK, finish up

'Save & close the MARCXML file
objStream.writetext "</marc:collection>"
objStream.savetofile strFileName, 2
objStream.Close


objKBARTFile.Close
Set objFSKBART = Nothing
Set objFSMARC = Nothing
Set objKBARTFile = Nothing
Set objStream = Nothing

End Sub
     
Sub GetDataFromJSON(strWSName As String, strDirectory As String, strProfileName As String)
Dim xmlHttp As Object
Dim xmlHttp2 As Object
Dim strReturn As String
Dim strURL As String
Dim varSplit As Variant
Dim intStart As Integer
Dim intEnd As Integer
Dim intRowCount As Integer
Dim strRetrieveLink As String
Dim x As Integer, y As Integer
Dim objFSKBART As Object
'Dim objKBARTFile As Object
Dim objFSMARC As Object
Dim objStreamMARC As Object
Dim objStreamKBART As Object
Dim strHANDLE As String
Dim strDocID As String
Dim strFileName As String

On Error Resume Next


ActiveWorkbook.Sheets(strWSName).Activate
intRowCount = Cells(Rows.Count, 1).End(xlUp).Row


    'Set objFS = CreateObject("ADODB.Stream")
    'objFS.Charset = "utf-8"
    'objFS.Open
    'objFS.WriteText sFileData
    'objFS.SaveToFile sOutFilePath, 2   '2: Create Or Update
    'objFS.Close

'Create a FileSystemObject to gather all the KBART texts
Set objFSKBART = CreateObject("Scripting.FileSystemObject")
'Here we create a stream object, and set the encoding to UTF-8
Set objStreamKBART = CreateObject("ADODB.Stream")
objStreamKBART.Charset = "UTF-8"
objStreamKBART.Open

'header KBART file
objStreamKBART.writetext "publication_title" & Chr(9) & "print_identifier" & Chr(9) & "online_identifier" & Chr(9) & "date_first_issue_online" & _
Chr(9) & "num_first_vol_online" & Chr(9) & "num_first_issue_online" & Chr(9) & "date_last_issue_online" & Chr(9) & "num_last_vol_online" & _
Chr(9) & "num_last_issue_online" & Chr(9) & "title_url" & Chr(9) & "first_author" & Chr(9) & "title_id" & Chr(9) & "embargo_info" & _
Chr(9) & "coverage_depth" & Chr(9) & "notes" & Chr(9) & "publisher_name" & Chr(9) & "publication_type" & Chr(9) & "date_monograph_published_print" & _
Chr(9) & "date_monograph_published_online" & Chr(9) & "monograph_volume" & Chr(9) & "monograph_edition" & Chr(9) & "first_editor" & _
Chr(9) & "parent_publication_title_id" & Chr(9) & "preceding_publication_title_id" & Chr(9) & "access_type" & Chr(9) & "OCLC_Control_Number" & Chr(10)


'Create a FileSystemObject to gather all the MARCXML XML data
Set objFSMARC = CreateObject("Scripting.FileSystemObject")
'Here we create a stream object, and set the encoding to UTF-8
Set objStreamMARC = CreateObject("ADODB.Stream")
objStreamMARC.Charset = "UTF-8"
objStreamMARC.Open

strFileName = strDirectory & strProfileName & "OAPEN_MARC.xml"
'header MARCXML file
objStreamMARC.writetext "<?xml version=" & Chr(34) & "1.0" & Chr(34) & " encoding=" & Chr(34) & "UTF-8" & _
Chr(34) & "?><marc:collection xmlns:marc=" & Chr(34) & "http://www.loc.gov/MARC21/slim" & Chr(34) & ">" & Chr(10)


For y = 2 To intRowCount
'For y = 2 To 15
'Start with line 2
    strDocID = Cells(y, 1)
    strHANDLE = Cells(y, 21)
    strHANDLE = Replace(strHANDLE, "http://library.oapen.org/handle/", "")
    strHANDLE = Replace(strHANDLE, "https://library.oapen.org/handle/", "")
     
    strURL = "https://library.oapen.org/rest/search?query=handle:%22" & strHANDLE & "%22&expand=metadata,bitstreams"
     

    'Open URL and get JSON data
    Set xmlHttp = CreateObject("MSXML2.ServerXMLHTTP.6.0")
    xmlHttp.Open "GET", strURL
    xmlHttp.setRequestHeader "Content-Type", "text/xml"
    xmlHttp.send
  
    'Save the response to a string
    strReturn = xmlHttp.responsetext

    'Split the JSON using the string "uuid": - all the bitstreams have a uuid
    varSplit = Split(strReturn, """uuid"":")
    For x = 1 To UBound(varSplit)
        'Get the MARCXML data, and write it to a separate file
        If InStr(varSplit(x), "marc.xml") Then
        'get the retrievelink for the MARCXML
            intStart = InStr(varSplit(x), """retrieveLink"":")
            intEnd = InStr(intStart, varSplit(x), ",")
            strRetrieveLink = Mid(varSplit(x), intStart, intEnd - intStart)
            strRetrieveLink = "https://library.oapen.org" & Replace(Replace(strRetrieveLink, """retrieveLink"":", ""), Chr(34), "")
            'Get the MARCXML and add it to the file
            Set xmlHttp2 = CreateObject("MSXML2.ServerXMLHTTP.6.0")
            xmlHttp2.Open "GET", strRetrieveLink
            xmlHttp2.setRequestHeader "Content-Type", "text/xml"
            xmlHttp2.send
            objStreamMARC.writetext Replace(Replace(xmlHttp2.responsetext, Chr(10), " "), Chr(13), " ") & Chr(10)
        End If
        
        'Get the KBART text and add it to a file
        If InStr(varSplit(x), ".tsv") Then
        'get the retrievelink for the KBART text
            intStart = InStr(varSplit(x), """retrieveLink"":")
            intEnd = InStr(intStart, varSplit(x), ",")
            strRetrieveLink = Mid(varSplit(x), intStart, intEnd - intStart)
            strRetrieveLink = "https://library.oapen.org" & Replace(Replace(strRetrieveLink, """retrieveLink"":", ""), Chr(34), "")
            'Get the KBART text and add it to the file
            Set xmlHttp2 = CreateObject("MSXML2.ServerXMLHTTP.6.0")
            xmlHttp2.Open "GET", strRetrieveLink
            xmlHttp2.setRequestHeader "Content-Type", "text/xml"
            xmlHttp2.send
            objStreamKBART.writetext xmlHttp2.responsetext & Chr(10)
        End If
    Next
'end of the loop
Next
'OK, finish up


objStreamKBART.savetofile strDirectory & strProfileName & "OAPEN_KBART.tsv", 2
objStreamKBART.Close

'Save & close the MARCXML file
objStreamMARC.writetext "</marc:collection>"
objStreamMARC.savetofile strFileName, 2
objStreamMARC.Close


Set objFSKBART = Nothing
Set objFSMARC = Nothing

Set objStreamMARC = Nothing
Set objStreamKBART = Nothing

End Sub
     

Private Function ExportToTextFile(strFile As String, strText As String) As String
    Dim objFSKBART As Object
    Dim objKBARTFile As Object
     
    Set objFSKBART = CreateObject("Scripting.FileSystemObject")
    Set objKBARTFile = objFSKBART.CreateTextFile(strFile)
     
    'waarschijnlijk dit gebruiken voor meedere teksten, loop
    objKBARTFile.Writeline strText
     
    objKBARTFile.Close
    Set objFSKBART = Nothing
    Set objKBARTFile = Nothing
End Function
Sub SaveXMLDoc(strURL As String, strDir As String, strID As String)

On Error Resume Next

Dim oStrm

'Nothing? Then skip
If strURL = "" Then Exit Sub

Dim HttpReq As Object
Set HttpReq = CreateObject("Microsoft.XMLHTTP")
HttpReq.Open "GET", strURL, False, "username", "password"
HttpReq.send

If HttpReq.Status = 200 Then
    Set oStrm = CreateObject("ADODB.Stream")
    oStrm.Open
    oStrm.Type = 1
    oStrm.Write HttpReq.responseBody
    oStrm.SaveTobjKBARTFile strDir & "\" & strID & ".xml", 2 ' 1 = no overwrite, 2 = overwrite
    oStrm.Close
End If


End Sub

Function GetKBARTdata(strURL As String) As String

'On Error Resume Next

Dim oStrm

'Nothing? Then skip
If strURL = "" Then Exit Function

Dim HttpReq As Object
Set HttpReq = CreateObject("Microsoft.XMLHTTP")
HttpReq.Open "GET", strURL, False, "username", "password"
HttpReq.send

If HttpReq.Status = 200 Then
    Set oStrm = CreateObject("ADODB.Stream")
    oStrm.Open
    oStrm.Type = 1
    oStrm.Write HttpReq.responseBody
    GetKBARTdata = oStrm.ReadText
    oStrm.Close
End If

End Function
Sub CreatExportFiles()

Call GetDataFromJSON("Profile 1", "c:\temp\", "Profile_1_")
Call GetDataFromJSON("Profile 2", "c:\temp\", "Profile_2_")
Call GetDataFromJSON("Profile 3", "c:\temp\", "Profile_3_")
Call GetDataFromJSON("Profile 4", "c:\temp\", "Profile_4_")
Call GetDataFromJSON("Profile 5", "c:\temp\", "Profile_5_")
Call GetDataFromJSON("Profile 6", "c:\temp\", "Profile_6_")
Call GetDataFromJSON("Profile 7", "c:\temp\", "Profile_7_")
Call GetDataFromJSON("Profile 8", "c:\temp\", "Profile_8_")
Call GetDataFromJSON("Profile 9", "c:\temp\", "Profile_9_")
'Call GetDataFromJSON("Profile 5", "c:\temp\", "Profile_5_")
'Call GetDataFromJSON("Profile 6", "c:\temp\", "Profile_6_")
'Call GetDataFromJSON("Profile 7", "c:\temp\", "Profile_7_")
'Call GetDataFromJSON("Profile 8", "c:\temp\", "Profile_8_")
'Call GetDataFromJSON("Profile 9", "c:\temp\", "Profile_9_")
Call GetDataFromJSON("Profile 10", "c:\temp\", "Profile_10_")
Call GetDataFromJSON("Test", "c:\temp\", "Test_")
MsgBox "fertig!"
End Sub
