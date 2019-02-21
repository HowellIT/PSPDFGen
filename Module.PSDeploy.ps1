Deploy Module {
    By PSGalleryModule {
        FromSource Build\PSPDFGen
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:PSGalleryKey
        }
    }
}