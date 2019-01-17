#Requires -Modules psake
[cmdletbinding()]
param(
    [string[]]$Task = 'manual'
)

$DependentModules = @('Pester','Psake','PlatyPS')
Foreach ($Module in $DependentModules){
    If (-not (Get-Module $module -ListAvailable)){
        Install-Module -name $Module -Scope CurrentUser
    }
    Import-Module $module -ErrorAction Stop
}
$env:ModuleTempDir = "$PSScriptRoot\build" #$env:TEMP
$env:ModuleName = "PS_PDFGeneratorAPI"
$env:Author = "Anthony Howell"
$env:ModuleVersion = "0.0.1"
[hashtable]$global:PrivateData = @{
    ProjectUri = 'https://github.com/ThePoShWolf/PS_PDFGeneratorAPI'
}
# Builds the module by invoking psake on the build.psake.ps1 script.
Invoke-PSake $PSScriptRoot\psake.ps1 -taskList $Task
