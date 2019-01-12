Function Get-PDFGenDocument {
    Param(
        [ValidateNotNullOrEmpty()]
        [string]$TemplateId,
        [hashtable]$Data,
        [ValidateSet('pdf','html','zip')]
        [string]$Format = 'pdf',
        [ValidateSet('base64','url')]
        [string]$Output = 'base64'
    )
    $resource = "templates/$TemplateId/output"

    $body = @{
        data = $Data
    }

    Invoke-PDFGeneratorAPICall -method Post -resource $resource -Body ($Data | ConvertTo-Json -Depth 5)
}