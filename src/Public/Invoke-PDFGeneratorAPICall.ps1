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