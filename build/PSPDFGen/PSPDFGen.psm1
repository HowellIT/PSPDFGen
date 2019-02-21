Function Get-PDFGenAuthConfig {
    Param(

    )
    If($AuthConfig){
        If(-not ($Silent.IsPresent)){
            $AuthConfig
        }
    }Else{
        $dir = Get-PDFGenSavePath
        If(Test-Path $dir\credentials.json){
            $encryptedAuth = Get-Content $dir\credentials.json | ConvertFrom-Json
        }
        $script:AuthConfig = @{}
        ForEach($property in $encryptedAuth.psobject.Properties){
            $AuthConfig."$($property.name)" = [pscredential]::New('user',(ConvertTo-SecureString $property.value)).GetNetworkCredential().password
        }
        If(-not ($Silent.IsPresent)){
            $AuthConfig
        }
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
Function Save-PDFGenAuthConfig {
    Param(

    )
    $dir = Get-PDFGenSavePath
    If(-not(Test-Path $dir -PathType Container)){
        New-Item $dir -ItemType Directory
    }
    If(-not(Test-Path $dir\credentials.json -PathType Leaf)){
        New-Item $dir\credentials.json -ItemType File
    }
    $encryptedAuth = @{}
    ForEach($property in $AuthConfig.GetEnumerator()){
        $encryptedAuth."$($property.Name)" = (ConvertFrom-SecureString (ConvertTo-SecureString $property.Value -AsPlainText -Force))
    }
    $encryptedAuth | ConvertTo-Json | Set-Content $dir\credentials.json
}
Function Get-PDFGenSavePath {
    Param (

    )
    If($PSVersionTable.PSVersion.Major -ge 6){
        # PS Core
        If($IsLinux){
            $saveDir = $env:HOME
        }ElseIf($IsWindows){
            $saveDir = $env:USERPROFILE
        }
    }Else{
        # Windows PS
        $saveDir = $env:USERPROFILE
    }
    "$saveDir\.pspdfgen"
}
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
