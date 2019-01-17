# https://pdfgeneratorapi.com/docs#templates-get-all
Function Get-PDFGenTemplates {
    Param(
        [ValidateNotNullOrEmpty()]
        [string]$key = $AuthConfig.key,
        [ValidateNotNullOrEmpty()]
        [string]$secret = $AuthConfig.secret,
        [ValidateNotNullOrEmpty()]
        [string]$workspace = $AuthConfig.workspace
    )

    (Invoke-PDFGeneratorAPICall -resource templates -method Get -key $key -secret $secret -workspace $workspace).response
}