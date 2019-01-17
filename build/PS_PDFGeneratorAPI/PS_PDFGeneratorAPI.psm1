# https://pdfgeneratorapi.com/docs#auth
Function Invoke-PDFGeneratorAPICall {
    Param(
        [string]$resource,
        [ValidateSet('Get','Post')]
        [string]$method,
        [ValidateNotNullOrEmpty()]
        [object]$authParams = (Get-Content C:\tmp\pdf.txt | Convertfrom-Json),
        [string]$body
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $baseuri = 'https://us1.pdfgeneratorapi.com/api/v3'

    $headers = @{
        'X-Auth-Key' = $authParams.key
        'X-Auth-Secret' = $authParams.secret
        'X-Auth-Workspace' = $authParams.workspace
        'Content-Type' = 'application/json'
        'Accept' = 'application/json'
    }

    If($body){
        Invoke-RestMethod -Uri "$baseuri/$resource" -Method $method -Headers $headers -Body $body
    }else{
        Invoke-RestMethod -Uri "$baseuri/$resource" -Method $method -Headers $headers
    }
}
# https://pdfgeneratorapi.com/docs#templates-output
Function Get-PDFGenDocument {
    Param(
        [ValidateNotNullOrEmpty()]
        [string]$TemplateId,
        [hashtable]$Data,
        [ValidateSet('pdf','html','zip')]
        [string]$Format = 'pdf',
        [ValidateSet('base64','url')]
        [string]$Output = 'base64',
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,
        [switch]$PassThru
    )
    $resource = "templates/$TemplateId/output/?format=$Format"

    $resp = Invoke-PDFGeneratorAPICall -method Post -resource $resource -Body ($Data | ConvertTo-Json -Depth 5)

    $bytes = [Convert]::FromBase64String($resp.response)
    [IO.File]::WriteAllBytes($FilePath, $bytes)
    If($PassThru.IsPresent){
        . $FilePath
    }
}
# https://pdfgeneratorapi.com/docs#templates-get-all
Function Get-PDFGenTemplates {
    Param(

    )

    (Invoke-PDFGeneratorAPICall -resource templates -method Get).response
}
<#
$data = @{
    InvoiceNum = '1122334455'
    InvoiceDate = '01/15/19'
    DueDate = '02/15/19'
    Client = @{
        Name = 'Howell IT, LLC'
        BillContact = 'Anthony Howell'
        BillAddrLine1 = '541 Willamette St'
        BillAddrLine2 = 'Ste 407B'
        BillCity = 'Eugene'
        BillState = 'OR'
        BillZip = '97401'
        Rate = '$80'
        BillEmail = 'anthony@howell-it.com'
    }
    Line = @(
        @{
            Date = '12/12/18'
            Notes = 'Ticket #5 Worked on computer adding some more text to make a really long example to see how the template performs.'
            LineQty = '1'
            LineTotal = '$80'
        },
        @{
            Date = '12/22/18'
            Notes = 'Ticket #10 Worked on network'
            LineQty = '1'
            LineTotal = '$80'
        })
    Subtotal = '$80'
    Discount = '0'
    Total = '$160'
}

$bytes = [Convert]::FromBase64String($d.response)
[IO.File]::WriteAllBytes('C:\tmp\test.pdf', $bytes)
#>
