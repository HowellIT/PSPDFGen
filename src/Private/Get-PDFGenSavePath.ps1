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