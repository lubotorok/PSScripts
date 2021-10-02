<#
    Command selects ale the files from inupt having the given rating.
    It looks in file metadata for the tag called Rating and its value.




.PARAMETER <Path>

.PARAMETER <Filter>

.NOTES
    AUTHOR Lubo Torok
    COPYRIGHT: 2021 by Lubo Torok
#>

# https://blog.kmsigma.com/2018/10/03/photo-organization-via-powershell-and-tags-part-2/

param($Photo)

# Script uses a .dll file for working with file tags. It needs to be loaded.
# TagLibSharp.dll library has to be located in the subfolder \script_libs.

#script startup with .dll loading
$script_location = $MyInvocation.MyCommand.Path
$script_directory = Split-Path $script_location -Parent

# Write-Host "Script runs from directory:" $script_directory

$TagLibrary = $script_directory + "\script_libs\TagLibSharp.dll"
[System.Reflection.Assembly]::LoadFile($TagLibrary) | Out-Null

$File = Get-ChildItem $Photo

$Imgfile = [TagLib.File]::Create($File.FullName)
Write-Output $ImgFile.ImageTag.Rating
