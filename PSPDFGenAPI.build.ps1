$srcPath = "$PSScriptRoot\src"
$buildPath = "$PSScriptRoot\build"
$moduleName = "PSPDFGen"
$modulePath = "$buildPath\$moduleName"
$author = 'Anthony Howell'
$version = '0.0.1'

task ModuleBuild {
    $pubFiles = Get-ChildItem "$srcPath\public" -Filter *.ps1 -File
    $privFiles = Get-ChildItem "$srcPath\private" -Filter *.ps1 -File
    If(-not(Test-Path $modulePath)){
        New-Item $modulePath -ItemType Directory
    }
    ForEach($file in ($pubFiles + $privFiles)) {
        Get-Content $file.FullName | Out-File "$modulePath\$moduleName.psm1" -Append -Encoding utf8
    }
    Copy-Item "$srcPath\$moduleName.psd1" -Destination $modulePath

    $moduleManifestData = @{
        Author = $author
        Copyright = "(c) $((get-date).Year) $author. All rights reserved."
        Path = "$modulePath\$moduleName.psd1"
        FunctionsToExport = $pubFiles.BaseName
        RootModule = "$moduleName.psm1"
        ModuleVersion = $version
        ProjectUri = 'https://github.com/theposhwolf/PS_PDFGeneratorAPI'
    }
    Update-ModuleManifest @moduleManifestData
    Import-Module $modulePath -RequiredVersion $version
}