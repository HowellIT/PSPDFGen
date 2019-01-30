Function New-PDFGenAuthConfig {
    Param (
        [ValidateNotNullOrEmpty()]
        [string]$key,
        [ValidateNotNullOrEmpty()]
        [string]$secret,
        [ValidateNotNullOrEmpty()]
        [string]$workspace
    )
    $Script:AuthConfig = @{
        key = $key
        secret = $secret
        workspace = $workspace
    }
}