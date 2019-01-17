# https://pdfgeneratorapi.com/docs#auth
Function Invoke-PDFGeneratorAPICall {
    Param(
        [string]$resource,
        [ValidateSet('Get','Post')]
        [string]$method,
        [ValidateNotNullOrEmpty()]
        [ValidateNotNullOrEmpty()]
        [string]$key = $AuthConfig.key,
        [ValidateNotNullOrEmpty()]
        [string]$secret = $AuthConfig.secret,
        [ValidateNotNullOrEmpty()]
        [string]$workspace = $AuthConfig.workspace,
        [string]$body
    )
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $baseuri = 'https://us1.pdfgeneratorapi.com/api/v3'

    $headers = @{
        'X-Auth-Key' = $key
        'X-Auth-Secret' = $secret
        'X-Auth-Workspace' = $workspace
        'Content-Type' = 'application/json'
        'Accept' = 'application/json'
    }

    If($body){
        Invoke-RestMethod -Uri "$baseuri/$resource" -Method $method -Headers $headers -Body $body
    }else{
        Invoke-RestMethod -Uri "$baseuri/$resource" -Method $method -Headers $headers
    }
}