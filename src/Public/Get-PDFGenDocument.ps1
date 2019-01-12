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