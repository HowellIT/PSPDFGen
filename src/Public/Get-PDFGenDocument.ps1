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
        [switch]$PassThru,
        [ValidateNotNullOrEmpty()]
        [string]$key = $AuthConfig.key,
        [ValidateNotNullOrEmpty()]
        [string]$secret = $AuthConfig.secret,
        [ValidateNotNullOrEmpty()]
        [string]$workspace = $AuthConfig.workspace
    )
    $resource = "templates/$TemplateId/output/?format=$Format"

    $resp = Invoke-PDFGeneratorAPICall -method Post -resource $resource -Body ($Data | ConvertTo-Json -Depth 5) -key $key -secret $secret -workspace $workspace

    $bytes = [Convert]::FromBase64String($resp.response)
    [IO.File]::WriteAllBytes($FilePath, $bytes)
    If($PassThru.IsPresent){
        . $FilePath
    }
}