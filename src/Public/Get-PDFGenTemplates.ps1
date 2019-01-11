Function Get-PDFGenTemplates {
    Param(

    )

    (Invoke-PDFGeneratorAPICall -resource templates -method Get).response
}