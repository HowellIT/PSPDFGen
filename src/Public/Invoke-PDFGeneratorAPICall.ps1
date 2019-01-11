Function Invoke-PDFGeneratorAPICall {
    Param(
        [string]$resource,
        [string]$method,
        [ValidateNotNullOrEmpty()]
        [object]$authParams = (Get-Content C:\tmp\pdf.txt | Convertfrom-Json)
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

    Invoke-RestMethod -Uri "$baseuri/$resource" -Method $method -Headers $headers
}