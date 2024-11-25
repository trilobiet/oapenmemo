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
Dim strDSpaceMail As String

Dim strAbstract As String
Dim strAuthor As String
Dim strBIC As String
Dim strBookTitle As String
Dim strChapterTitle As String
Dim strCoverURL As String
Dim strDateNow As String
Dim strDOI As String
Dim strDownload As String
Dim strEditor As String
Dim strFunder As String
Dim strGrantnumber As String
Dim strImprint As String
Dim strISBN As String
Dim strISBNOther As String
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
Dim varEditor As Variant
Dim varFunder As Variant
Dim varGrantnumber As Variant
Dim varISBN As Variant
Dim varISBNOther As Variant
Dim varJurisdiction As Variant
Dim varKeyword As Variant
Dim varLanguage As Variant
Dim varOther As Variant
Dim varProgramname As Variant
Dim varProjectacronym As Variant
Dim varProjectname As Variant


Dim p As Integer
Dim q As Integer
Dim r As Integer
Dim s As Integer
Dim x As Integer
Dim y As Integer
Dim z As Integer
Function MakeFolder(strFolder As String)

If Len(Dir(strFolder, vbDirectory)) = 0 Then
   MkDir strFolder
End If
End Function

Sub ExportToONIX()
Dim strScriptTextOAPEN As String
Dim strScriptTextDOAB As String
Dim strScriptUploadOAPEN As String
Dim strScriptUploadDOAB As String
Dim objScript
Dim objTxtStream
Dim strShortName As String
Dim strMailText 'no string, returnvalue might be FALSE (Boolean)
Dim strMailAddress As String

strDateNow = Year(Now) & Right("0" & Month(Now), 2) & Right("0" & Day(Now), 2)
z = 0

'directory and file name
strDirectory = ActiveWorkbook.Sheets("Start").Range("F17").value
If Right(strDirectory, 1) <> "\" Then
    strDirectory = strDirectory & "\"
End If

strShortName = "ONIX2OAPEN_" & strDateNow & "-" & Right("0" & Hour(Now), 2) & Right("0" & Minute(Now), 2) & Right("0" & Second(Now), 2)
strFileName = strDirectory & strShortName
strMailAddress = ActiveWorkbook.Sheets("Start").Range("F22").value
strMailText = Application.InputBox("What mail adress to use?", Type:=2, Title:="Identification, please", Default:=strMailAddress)

'OK, somebody pressed cancel!
If strMailText = False Then Exit Sub

'Create a script to upload the ONIX file to the DSpace server
strScriptTextOAPEN = "cd " & strDirectory & Chr(13)
strScriptTextDOAB = "cd " & strDirectory & Chr(13)
strScriptUploadOAPEN = "ssh dspace@oapen-prod.atmire.com" & Chr(13)
strScriptUploadDOAB = "ssh dspace@doab-prod.atmire.com" & Chr(13)


strSenderOrg = ActiveWorkbook.Sheets("Start").Range("F19").value
strSenderMail = ActiveWorkbook.Sheets("Start").Range("F20").value

ActiveWorkbook.Sheets("BookData").Activate
intRowCount = Cells(Rows.Count, 1).End(xlUp).Row
'integer division, use a back slash
intExportCount = (intRowCount - 1) \ 250

'create ONIX files with no more than 250 titles
If intExportCount = 0 Then
    strFileName = strFileName & ".xml"
    Call CreateFile(strFileName, 2, intRowCount) 'we start at line 2
    
    'Add the name of the ONIX file to be uploaded
    strScriptTextOAPEN = strScriptTextOAPEN & "scp " & strShortName & ".xml" & " dspace@oapen-prod.atmire.com:/tmp/" & strShortName & ".xml" & Chr(13)
    strScriptTextDOAB = strScriptTextDOAB & "scp " & strShortName & ".xml" & " dspace@doab-prod.atmire.com:/tmp/" & strShortName & ".xml" & Chr(13)
    strScriptUploadOAPEN = strScriptUploadOAPEN & Chr(13) & "./dspace/bin/dspace dsrun com.atmire.onix.scripts.OnixParseScriptClient -c 20.500.12657/6 -e " _
    & strMailText & " -f /tmp/" & strShortName & ".xml" & Chr(13)
    strScriptUploadDOAB = strScriptUploadDOAB & Chr(13) & "./dspace/bin/dspace dsrun com.atmire.onix.scripts.OnixParseScriptClient -c 20.500.12854/6 -e " _
    & strMailText & " -f /tmp/" & strShortName & ".xml" & Chr(13)
Else
    For p = 0 To intExportCount
        q = p * 250
        r = q + 250
        If r > intRowCount Then r = intRowCount
        
        If p = 0 Then
            Call CreateFile(strFileName & "_" & CStr(p) & ".xml", 2, 250)  'we start at line 2
        Else
            Call CreateFile(strFileName & "_" & CStr(p) & ".xml", q + 1, r)
        End If
        
        'Add the name of all the ONIX files to be uploaded
        strScriptTextOAPEN = strScriptTextOAPEN & Chr(13) & "scp " & strShortName & "_" & CStr(p) & ".xml" & " dspace@oapen-prod.atmire.com:/tmp/" & strShortName & "_" & CStr(p) & ".xml" & Chr(13)
        strScriptTextDOAB = strScriptTextDOAB & Chr(13) & "scp " & strShortName & "_" & CStr(p) & ".xml" & " dspace@doab-prod.atmire.com:/tmp/" & strShortName & "_" & CStr(p) & ".xml" & Chr(13)
        strScriptUploadOAPEN = strScriptUploadOAPEN & Chr(13) & "./dspace/bin/dspace dsrun com.atmire.onix.scripts.OnixParseScriptClient -c 20.500.12657/6 -e " _
        & ActiveWorkbook.Sheets("Start").Range("F22").value & " -f /tmp/" & strShortName & "_" & CStr(p) & ".xml" & Chr(13)
        strScriptUploadDOAB = strScriptUploadDOAB & Chr(13) & "./dspace/bin/dspace dsrun com.atmire.onix.scripts.OnixParseScriptClient -c 20.500.12854/6 -e " _
        & ActiveWorkbook.Sheets("Start").Range("F22").value & " -f /tmp/" & strShortName & "_" & CStr(p) & ".xml" & Chr(13)
        
    Next

End If

'Write the script to a text file
Set objScript = CreateObject("Scripting.FileSystemObject")
Set objTxtStream = objScript.createtextfile(strDirectory & strShortName & "_OAPEN-script.txt", True, True)
objTxtStream.WriteLine (strScriptTextOAPEN)
objTxtStream.WriteLine (strScriptUploadOAPEN)
objTxtStream.Close

Set objScript = CreateObject("Scripting.FileSystemObject")
Set objTxtStream = objScript.createtextfile(strDirectory & strShortName & "_DOAB-script.txt", True, True)
objTxtStream.WriteLine (strScriptTextDOAB)
objTxtStream.WriteLine (strScriptUploadDOAB)
objTxtStream.Close


If intExportCount = 0 Then
    strMessage = "You have now exported the data of " & CStr(intRowCount - 1) & " title(s) to the file " & strFileName & "."
Else
    strMessage = "You have now exported the data of " & CStr(intRowCount - 1) & " titles to " & CStr(p) & " files, named " & strFileName & "_0.xml to " _
        & strFileName & "_" & CStr(p - 1) & ".xml"
End If

strMessage = strMessage & Chr(13) & Chr(13) & "Use the script " & strShortName & "_OAPEN-script.txt or " & strShortName & "_DOAB-script.txt" & " to upload the ONIX file to the DSpace server"

'message depends on status of chapters
If z > 0 Then
    MsgBox "Not all title information has been exported to ONIX!" & Chr(13) & Chr(13) & strMessage & Chr(13) & Chr(13) & _
    "However, the data of " & CStr(z) & " chapters have been omitted!", vbCritical, "Error"
Else
    MsgBox strMessage, vbInformation, "Export is finished"
End If

End Sub
Sub WriteXML(strFile As String, intRow As Integer)

'Columns:
'1. Type of Document (Book or Chapter)
'2. Book Title
'3. Subtitle
'4. Chapter Title
'5. Authors - separate with ; - ORCID between ()
'6. Editors  - separate with ; - ORCID between ()
'7. Other Contributors  - separate with ; - ORCID between ()
'8. BIC classification - separate with ;
'9. Keywords (English)
'10. Publisher
'11. Year of publication (YYYY format)
'12. Place of publication
'13. Primary ISBN
'14. Other ISBNs - separate with ;
'15. DOI
'16. Imprint
'17. Series title
'18. Series number
'19. Series ISSN
'20. Abstract (English)
'21. Language(s) of the publication - separate with ; - based on ISO 639-2B
'22. Number of Pages
'23. Rights
'24. Link to web shop
'25. Link to download title
'26. Link to cover file
'27. Funder name
'28. Funding program name
'29. Funding project name
'30. Funding: project acronym
'31. Funding: grant number
'32. Funding: jurisdiction


'Put the values in variables, change where needed
strPubType = Cells(intRow, 1)

'For now: chapters are excluded!
If InStr(LCase(strPubType), "chap") > 0 Then
    z = z + 1
Else

strBookTitle = TidyText(Cells(intRow, 2))
strSubTitle = TidyText(Cells(intRow, 3))
strChapterTitle = TidyText(Cells(intRow, 4))
strAuthor = Cells(intRow, 5)
varAuthor = Split(strAuthor, ";")
strEditor = Cells(intRow, 6)
varEditor = Split(strEditor, ";")
strOther = Cells(intRow, 7)
varOther = Split(strOther, ";")
strBIC = Cells(intRow, 8)
strBIC = Replace(strBIC, " ", "")
varBic = Split(strBIC, ";")
strKeyword = Cells(intRow, 9)
varKeyword = Split(strKeyword, ";")
strPublisher = TidyText(Cells(intRow, 10))
strYear = Left(Cells(intRow, 11), 4)
strPlace = Cells(intRow, 12)
strISBN = Cells(intRow, 13)
strISBN = Replace(strISBN, " ", "")
strISBN = Replace(strISBN, "-", "")
varISBN = Split(strISBN, ";")
strISBNOther = Cells(intRow, 14)
strISBNOther = Replace(strISBNOther, " ", "")
strISBNOther = Replace(strISBNOther, "-", "")
varISBNOther = Split(strISBNOther, ";")
'add possible extra ISBNs to varISBNOther
If UBound(varISBN) > 0 Then
    For x = 1 To UBound(varISBN)
        s = UBound(varISBNOther) + 1
        ReDim Preserve varISBNOther(s)
        varISBNOther(s) = varISBN(x)
    Next
End If
strDOI = Cells(intRow, 15)
strDOI = Replace(strDOI, "https://doi.org/", "")
strDOI = Replace(strDOI, "http://doi.org/", "")
strDOI = Replace(strDOI, Chr(10), " ")
strDOI = Replace(strDOI, Chr(13), " ")
strImprint = TidyText(Cells(intRow, 16))
strSeriesTitle = TidyText(Cells(intRow, 17))
strSeriesNumber = Cells(intRow, 18)
strSeriesISSN = Cells(intRow, 19)
strAbstract = TidyText(HtmlDecode(Cells(intRow, 20)))
strLanguage = Cells(intRow, 21)
strLanguage = Replace(strLanguage, " ", "")
varLanguage = Split(strLanguage, ";")
strPages = Cells(intRow, 22)
strLicense = Cells(intRow, 23)
strWebshop = TidyText(Cells(intRow, 24))
strDownload = TidyText(Cells(intRow, 25))
strCoverURL = TidyText(Cells(intRow, 26))
strFunder = Cells(intRow, 27)
varFunder = Split(strFunder, ";")
strProgramname = Cells(intRow, 28)
varProgramname = Split(strProgramname, ";")
strProjectname = Cells(intRow, 29)
varProjectname = Split(strProjectname, ";")
strProjectacronym = Cells(intRow, 30)
varProjectacronym = Split(strProjectacronym, ";")
strGrantnumber = Cells(intRow, 31)
varGrantnumber = Split(strGrantnumber, ";")
strJurisdiction = Cells(intRow, 32)
varJurisdiction = Split(strJurisdiction, ";")

'first block
objStream.WriteText ("<Product>" & Chr(10))
objStream.WriteText ("<RecordReference>")
objStream.WriteText ("ONIX_" & strDateNow & "_" & CStr(varISBN(0)) & "_" & CStr(intRow))
objStream.WriteText ("</RecordReference>" & Chr(10))
objStream.WriteText ("<NotificationType>03</NotificationType>" & Chr(10))
objStream.WriteText ("<RecordSourceType>00</RecordSourceType>" & Chr(10))
objStream.WriteText ("<ProductIdentifier>" & Chr(10))
objStream.WriteText ("<ProductIDType>01</ProductIDType>" & Chr(10))
objStream.WriteText ("<IDValue>")
objStream.WriteText ("ONIX_" & strDateNow & "_" & CStr(varISBN(0)) & "_" & CStr(intRow))
objStream.WriteText ("</IDValue>" & Chr(10))
objStream.WriteText ("</ProductIdentifier>" & Chr(10))

'ISBN (primary)
Call WriteIdentifier(CStr(varISBN(0)), "15")

'doi
If strDOI <> "" Then
    Call WriteIdentifier(strDOI, "06")
End If

'descriptive detail block
objStream.WriteText ("<DescriptiveDetail>" & Chr(10))
objStream.WriteText ("<ProductComposition>00</ProductComposition>" & Chr(10))
objStream.WriteText ("<ProductForm>EB</ProductForm>" & Chr(10))
objStream.WriteText ("<ProductFormDetail>E107</ProductFormDetail>" & Chr(10))
objStream.WriteText ("<PrimaryContentType>10</PrimaryContentType>" & Chr(10))
objStream.WriteText ("<EpubLicense>" & Chr(10))
'license: CC or all rights reserved?
If InStr(LCase(strLicense), "commons") > 0 Then
    objStream.WriteText ("<EpubLicenseName>Creative Commons License</EpubLicenseName>" & Chr(10))
Else
    objStream.WriteText ("<EpubLicenseName>Publisher's license</EpubLicenseName>" & Chr(10))
End If
objStream.WriteText ("<EpubLicenseExpression>" & Chr(10))
objStream.WriteText ("<EpubLicenseExpressionType>02</EpubLicenseExpressionType>" & Chr(10))
objStream.WriteText ("<EpubLicenseExpressionLink>")
objStream.WriteText (strLicense)
objStream.WriteText ("</EpubLicenseExpressionLink>" & Chr(10))
objStream.WriteText ("</EpubLicenseExpression>" & Chr(10))
objStream.WriteText ("</EpubLicense>" & Chr(10))

'series
If strSeriesTitle <> "" Then
    objStream.WriteText ("<Collection>" & Chr(10))
    objStream.WriteText ("<CollectionType>10</CollectionType>" & Chr(10))
    If strSeriesISSN <> "" Then
        objStream.WriteText ("<CollectionIdentifier>" & Chr(10))
        objStream.WriteText ("<CollectionIDType>02</CollectionIDType>" & Chr(10))
        objStream.WriteText ("<IDValue>")
        objStream.WriteText (strSeriesISSN)
        objStream.WriteText ("</IDValue>" & Chr(10))
        objStream.WriteText ("</CollectionIdentifier>" & Chr(10))
    End If
    objStream.WriteText ("<TitleDetail>" & Chr(10))
    objStream.WriteText ("<TitleType>01</TitleType>" & Chr(10))
    objStream.WriteText ("<TitleElement>" & Chr(10))
    objStream.WriteText ("<TitleElementLevel>02</TitleElementLevel>" & Chr(10))
    If strSeriesNumber <> "" Then
        objStream.WriteText ("<PartNumber>")
        objStream.WriteText (strSeriesNumber)
        objStream.WriteText ("</PartNumber>" & Chr(10))
    End If
    objStream.WriteText ("<TitleText>")
    objStream.WriteText (strSeriesTitle)
    objStream.WriteText ("</TitleText>" & Chr(10))
    objStream.WriteText ("</TitleElement>" & Chr(10))
    objStream.WriteText ("</TitleDetail>" & Chr(10))
    objStream.WriteText ("</Collection>" & Chr(10))
End If

'title
objStream.WriteText ("<TitleDetail>" & Chr(10))
objStream.WriteText ("<TitleType>01</TitleType>" & Chr(10))
objStream.WriteText ("<TitleElement>" & Chr(10))
objStream.WriteText ("<TitleElementLevel>01</TitleElementLevel>" & Chr(10))
objStream.WriteText ("<TitleText>")
objStream.WriteText (strBookTitle)
objStream.WriteText ("</TitleText>" & Chr(10))
If strSubTitle <> "" Then
    objStream.WriteText ("<Subtitle>")
    objStream.WriteText (strSubTitle)
    objStream.WriteText ("</Subtitle>" & Chr(10))
End If
objStream.WriteText ("</TitleElement>" & Chr(10))
objStream.WriteText ("</TitleDetail>" & Chr(10))

'author(s)
Call ContributorData(varAuthor, "A01")
'editor(s)
Call ContributorData(varEditor, "B01")
'other(s)
Call ContributorData(varOther, "Z99")

'language
For x = 0 To UBound(varLanguage)
    objStream.WriteText ("<Language>" & Chr(10))
    objStream.WriteText ("<LanguageRole>01</LanguageRole>" & Chr(10))
    objStream.WriteText ("<LanguageCode>")
    objStream.WriteText (Trim(varLanguage(x)))
    objStream.WriteText ("</LanguageCode>" & Chr(10))
    objStream.WriteText ("</Language>" & Chr(10))
Next
'pages
If strPages <> "" Then
    objStream.WriteText ("<Extent>" & Chr(10))
    objStream.WriteText ("<ExtentType>00</ExtentType>" & Chr(10))
    objStream.WriteText ("<ExtentValue>")
    objStream.WriteText (strPages)
    objStream.WriteText ("</ExtentValue>" & Chr(10))
    objStream.WriteText ("<ExtentUnit>03</ExtentUnit>" & Chr(10))
    objStream.WriteText ("</Extent>" & Chr(10))
End If

'subject: BIC
For x = 0 To UBound(varBic)
    objStream.WriteText ("<Subject>" & Chr(10))
    objStream.WriteText ("<SubjectSchemeIdentifier>12</SubjectSchemeIdentifier>" & Chr(10))
    objStream.WriteText ("<SubjectCode>")
    objStream.WriteText (Trim(varBic(x)))
    objStream.WriteText ("</SubjectCode>" & Chr(10))
    objStream.WriteText ("</Subject>" & Chr(10))
Next

'subject: keywords
If strKeyword <> "" Then
    For x = 0 To UBound(varKeyword)
        objStream.WriteText ("<Subject>" & Chr(10))
        objStream.WriteText ("<SubjectSchemeIdentifier>20</SubjectSchemeIdentifier>" & Chr(10))
        objStream.WriteText ("<SubjectHeadingText>")
        objStream.WriteText (Trim(TidyText(varKeyword(x))))
        objStream.WriteText ("</SubjectHeadingText>" & Chr(10))
        objStream.WriteText ("</Subject>" & Chr(10))
    Next
End If

'end descriptive detail block
objStream.WriteText ("<Audience>" & Chr(10))
objStream.WriteText ("<AudienceCodeType>01</AudienceCodeType>" & Chr(10))
objStream.WriteText ("<AudienceCodeValue>06</AudienceCodeValue>" & Chr(10))
objStream.WriteText ("</Audience>" & Chr(10))
objStream.WriteText ("</DescriptiveDetail>" & Chr(10))

'collateral detail block
objStream.WriteText ("<CollateralDetail>" & Chr(10))
'abstract
objStream.WriteText ("<TextContent>" & Chr(10))
objStream.WriteText ("<TextType>03</TextType>" & Chr(10))
objStream.WriteText ("<ContentAudience>03</ContentAudience>" & Chr(10))
objStream.WriteText ("<Text language='eng'>")
'No abstract? Use the keywords instead
If strAbstract = "" Then
    objStream.WriteText (strKeyword)
Else
    objStream.WriteText (strAbstract)
End If
objStream.WriteText ("</Text>" & Chr(10))
objStream.WriteText ("</TextContent>" & Chr(10))
'cover image
If strCoverURL <> "" Then
    objStream.WriteText ("<SupportingResource>" & Chr(10))
    objStream.WriteText ("<ResourceContentType>01</ResourceContentType>" & Chr(10))
    objStream.WriteText ("<ContentAudience>00</ContentAudience>" & Chr(10))
    objStream.WriteText ("<ResourceMode>03</ResourceMode>" & Chr(10))
    objStream.WriteText ("<ResourceVersion>" & Chr(10))
    objStream.WriteText ("<ResourceForm>02</ResourceForm>" & Chr(10))
    objStream.WriteText ("<ResourceLink>")
    objStream.WriteText (strCoverURL)
    objStream.WriteText ("</ResourceLink>" & Chr(10))
    objStream.WriteText ("</ResourceVersion>" & Chr(10))
    objStream.WriteText ("</SupportingResource>" & Chr(10))
End If
'end collateral detail block
objStream.WriteText ("</CollateralDetail>" & Chr(10))

'publishing detail block
objStream.WriteText ("<PublishingDetail>" & Chr(10))
'imprint
If strImprint <> "" Then
    objStream.WriteText ("<Imprint>" & Chr(10))
    objStream.WriteText ("<ImprintName>")
    objStream.WriteText (strImprint)
    objStream.WriteText ("</ImprintName>" & Chr(10))
    objStream.WriteText ("</Imprint>" & Chr(10))
End If
'publisher name
objStream.WriteText ("<Publisher>" & Chr(10))
objStream.WriteText ("<PublishingRole>01</PublishingRole>" & Chr(10))
objStream.WriteText ("<PublisherName>")
objStream.WriteText (strPublisher)
objStream.WriteText ("</PublisherName>" & Chr(10))
objStream.WriteText ("</Publisher>" & Chr(10))

'funding
If strFunder <> "" Then
    For x = 0 To UBound(varFunder)
    'always add grant number data, otherwise the data won't be exported
    If strGrantnumber <> "" Then
        Call FundingData("grantnumber", varGrantnumber(x), varFunder(x))
    Else
        Call FundingData("grantnumber", "[...]", varFunder(x))
    End If
    'other funding data
    If strProgramname <> "" Then
        Call FundingData("programname", varProgramname(x), varFunder(x))
    End If
    If strProjectname <> "" Then
        Call FundingData("projectname", varProjectname(x), varFunder(x))
    End If
    If strProjectacronym <> "" Then
        Call FundingData("projectacronym", varProjectacronym(x), varFunder(x))
    End If
    If strJurisdiction <> "" Then
        Call FundingData("jurisdiction", varJurisdiction(x), varFunder(x))
    End If
    Next
End If
'place
If strPlace <> "" Then
    objStream.WriteText ("<CityOfPublication>")
    objStream.WriteText (strPlace)
    objStream.WriteText ("</CityOfPublication>" & Chr(10))
End If
'publishing status
objStream.WriteText ("<PublishingStatus>00</PublishingStatus>" & Chr(10))
'publication year
objStream.WriteText ("<PublishingDate>" & Chr(10))
objStream.WriteText ("<PublishingDateRole>01</PublishingDateRole>" & Chr(10))
objStream.WriteText ("<Date dateformat='05'>")
objStream.WriteText (strYear)
objStream.WriteText ("</Date>" & Chr(10))
objStream.WriteText ("</PublishingDate>" & Chr(10))
'end block
objStream.WriteText ("</PublishingDetail>" & Chr(10))

'related Product block
If UBound(varISBNOther) > -1 Then
    objStream.WriteText ("<RelatedMaterial>" & Chr(10))
    objStream.WriteText ("<RelatedProduct>" & Chr(10))
    objStream.WriteText ("<ProductRelationCode>06</ProductRelationCode>" & Chr(10))
    'all the ISBNs

    For x = 0 To UBound(varISBNOther)
        Call WriteIdentifier(CStr(varISBNOther(x)), "15")
    Next

    'end related product block
    objStream.WriteText ("</RelatedProduct>" & Chr(10))
    objStream.WriteText ("</RelatedMaterial>" & Chr(10))
End If

'supply detail block
objStream.WriteText ("<ProductSupply>" & Chr(10))

'websites: download URL
If strDownload <> "" Then
    objStream.WriteText ("<SupplyDetail>" & Chr(10))
    objStream.WriteText ("<Supplier>" & Chr(10))
    objStream.WriteText ("<SupplierRole>11</SupplierRole>" & Chr(10))
    objStream.WriteText ("<SupplierName>")
    objStream.WriteText (strPublisher)
    objStream.WriteText ("</SupplierName>" & Chr(10))
    objStream.WriteText ("<Website>" & Chr(10))
    objStream.WriteText ("<WebsiteRole>01</WebsiteRole>" & Chr(10))
    objStream.WriteText ("<WebsiteDescription>Publisher's website: download the title</WebsiteDescription>" & Chr(10))
    objStream.WriteText ("<WebsiteLink>")
    objStream.WriteText (strDownload)
    objStream.WriteText ("</WebsiteLink>" & Chr(10))
    objStream.WriteText ("</Website>" & Chr(10))
    objStream.WriteText ("</Supplier>" & Chr(10))
    objStream.WriteText ("<ProductAvailability>99</ProductAvailability>" & Chr(10))
    objStream.WriteText ("<UnpricedItemType>04</UnpricedItemType>" & Chr(10))
    objStream.WriteText ("</SupplyDetail>" & Chr(10))
End If

'websites: publisher web shop
If strWebshop <> "" Then
    objStream.WriteText ("<SupplyDetail>" & Chr(10))
    objStream.WriteText ("<Supplier>" & Chr(10))
    objStream.WriteText ("<SupplierRole>09</SupplierRole>" & Chr(10))
    objStream.WriteText ("<SupplierName>")
    objStream.WriteText (strPublisher)
    objStream.WriteText ("</SupplierName>" & Chr(10))
    objStream.WriteText ("<Website>" & Chr(10))
    objStream.WriteText ("<WebsiteRole>01</WebsiteRole>" & Chr(10))
    objStream.WriteText ("<WebsiteDescription>Publisher's website: web shop</WebsiteDescription>" & Chr(10))
    objStream.WriteText ("<WebsiteLink>")
    objStream.WriteText (strWebshop)
    objStream.WriteText ("</WebsiteLink>" & Chr(10))
    objStream.WriteText ("</Website>" & Chr(10))
    objStream.WriteText ("</Supplier>" & Chr(10))
    objStream.WriteText ("<ProductAvailability>99</ProductAvailability>" & Chr(10))
    objStream.WriteText ("<UnpricedItemType>04</UnpricedItemType>" & Chr(10))
    objStream.WriteText ("</SupplyDetail>" & Chr(10))
End If

'end of block, end of description
objStream.WriteText ("</ProductSupply>" & Chr(10))
objStream.WriteText ("</Product>" & Chr(10))


'!!!
'end of the check for chapters
End If

End Sub
Sub FundingData(strType As String, strText, strGrantor)
        objStream.WriteText ("<Publisher>" & Chr(10))
        objStream.WriteText ("<PublishingRole>16</PublishingRole>" & Chr(10))
        objStream.WriteText ("<PublisherName>")
        objStream.WriteText (TidyText(strGrantor))
        objStream.WriteText ("</PublisherName>" & Chr(10))
        objStream.WriteText ("<Funding>" & Chr(10))
        objStream.WriteText ("<FundingIdentifier>" & Chr(10))
        objStream.WriteText ("<FundingIDType>01</FundingIDType>" & Chr(10))
        objStream.WriteText ("<IDTypeName>" & strType & "</IDTypeName>" & Chr(10))
        objStream.WriteText ("<IDValue>")
        objStream.WriteText (TidyText(strText))
        objStream.WriteText ("</IDValue>" & Chr(10))
        objStream.WriteText ("</FundingIdentifier>" & Chr(10))
        objStream.WriteText ("</Funding>" & Chr(10))
        objStream.WriteText ("</Publisher>" & Chr(10))
End Sub
Sub ContributorData(varContributor As Variant, strType As String)
Dim varContrib As Variant
Dim varFirstLast As Variant
Dim strContribName As String
Dim strFirstName As String
Dim strLastName As String
Dim varName As Variant
Dim strORCID As String
Dim a

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
                For a = 1 To UBound(varFirstLast)
                    'what to do with John M. Doe?
                    If Right(varFirstLast(a), 1) = "." Then
                        strFirstName = Trim(strFirstName & " " & varFirstLast(a))
                    Else
                        strLastName = Trim(strLastName & " " & varFirstLast(a))
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
strTXT = Replace(strTXT, "<", "&lt;")
strTXT = Replace(strTXT, ">", "&gt;")
strTXT = Replace(strTXT, Chr(34), "&quot;")
strTXT = Replace(strTXT, "'", "&apos;")
TidyText = Trim(strTXT)
End Function
Sub WriteIdentifier(strValue As String, strType As String)
objStream.WriteText ("<ProductIdentifier>" & Chr(10))
objStream.WriteText ("<ProductIDType>" & strType & "</ProductIDType>" & Chr(10))
objStream.WriteText ("<IDValue>")
objStream.WriteText (strValue)
objStream.WriteText ("</IDValue>" & Chr(10))
objStream.WriteText ("</ProductIdentifier>" & Chr(10))
End Sub
Sub CreateFile(strFileName As String, intFirst As Integer, intLast As Integer)
'create a XML file
Set objStream = CreateObject("ADODB.Stream")
objStream.Charset = "UTF-8"

objStream.Open
'start - header
objStream.WriteText ("<?xml version='1.0' encoding='UTF-8'?>" & Chr(10))
objStream.WriteText ("<ONIXMessage xmlns='http://ns.editeur.org/onix/3.0/reference' release='3.0'>" & Chr(10))
objStream.WriteText ("<Header>" & Chr(10))
objStream.WriteText ("<Sender>" & Chr(10))
objStream.WriteText ("<SenderName>")
objStream.WriteText strSenderOrg
objStream.WriteText ("</SenderName>" & Chr(10))
objStream.WriteText ("<EmailAddress>")
objStream.WriteText (strSenderMail)
objStream.WriteText ("</EmailAddress>" & Chr(10))
objStream.WriteText ("</Sender>" & Chr(10))
objStream.WriteText ("<SentDateTime>")
objStream.WriteText (strDateNow)
objStream.WriteText ("</SentDateTime>" & Chr(10))
objStream.WriteText ("</Header>" & Chr(10))

'write the data of the publications into the file
For y = intFirst To intLast
    Call WriteXML(strFileName, y)
Next

'wrap it up
objStream.WriteText ("</ONIXMessage>" & Chr(10))

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

