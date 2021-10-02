PowerShell scripts for selecting, filtering and displaying photos.

# Get-PhotoRating
Gets the rating tag of the photo and sends it to the output for further processing.
Script is using TagLibSharp.dll in script_libs folder. You have to download it by yourself.
See readme in the script_libs folder.

# Select-Photo
Selects a subset from files from input or from a given Path filtered by Filter 
and having rating specified by -RatingFrom and -RatingTo parameters.

# Generate-Album
Generates a very simple HTML output which can be further processed by pipeline.

# Show-Html
Script shows HTML source from the input in a simple .NET component as a web page.
It is used to show the output of the Generate-Album command.
