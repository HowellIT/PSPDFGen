# https://pdfgeneratorapi.com/docs#templates-get-all
Function Get-PDFGenTemplates {
    Param(

    )

    (Invoke-PDFGeneratorAPICall -resource templates -method Get).response
}