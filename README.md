# PS_PDFGeneratorAPI

This is a PowerShell module to work with PDF Generator API: https://pdfgeneratorapi.com/

## How to set up

Publishing to the PSGallery soon.

Download or clone this repo and:

```PowerShell
Import-module $ModulePath\build\PS_PDFGeneratorAPI
```
## How to configure authentication

Create the module's auth:

```PowerShell
New-PDFGenAuthConfig -key <key> -secret <secret> -workspace <workspace>
```
To be able to use this module, you must already have a PDF Generator API account.

Now you can also save the auth data:

```PowerShell
Save-PDFGenAuthConfig
```

And load it from local storage:

```PowerShell
Get-PDFGenAuthConfig
```

This stores the info encrypted in your home directory\.pspdfgen\credentials.json (works on PS Core!)

**After this is run, the cmdlets no longer require explicit authentication.**

## How to use

To retrieve available templates:

```PowerShell
Get-PDFGenTemplates
```

To generate a document based on their invoice template using partial example data:

```PowerShell
$ht = @{
    TxnDate = (Get-Date).ToShortDateString()
    DueDate = (Get-Date).AddDays(30).ToShortDateString()
    CustomerInfo = @{
        CompanyName = 'Contoso'
    }
    Line = @(
        @{
            Name = 'Line 1'
            Description = 'Data on line 1'
        },
        @{
            Name = 'Line 2'
            Description = 'Data on line 2'
        }
    )
    TotalAmt = '$1000'
}
Get-PDFGenDocument -TemplateId 21648 -Data $ht -Format pdf -Output base64 -FilePath C:\Path\to\doc.pdf -PassThru
```

This will output a .pdf to the filepath specified.