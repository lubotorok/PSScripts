<#
    Command selects files based on the entered conditions concerning
    file metadata.

    .PARAMETER <RatingFrom>
    Minimal rating of the selected file (inclusive)

    .PARAMETER <RatingTo>
    Maximal rating of the selected file (inclusive)

    .PARAMETER <Filter>
    File filter used to filter files in Path.

    .PARAMETER <Path>
    Path to list file from. Filter ma be applied using -Filter parameter.

    .NOTES
    AUTHOR Lubo Torok
    COPYRIGHT: 2021 by Lubo Torok
#>

param ([int]$ratingFrom, [int]$ratingTo, $Filter, $Path)

#inputs checks
if (-not($PSBoundParameters.ContainsKey('Path')))  #if Path parameter was not entered via the -Path parameter
{
    if ($args.Length -ge 0){
        $Path = $args[0]  #use the first argument as a path
    }
}

if (!($PSBoundParameters.ContainsKey('RatingFrom'))){
    $ratingFrom = -10000
}

if (!($PSBoundParameters.ContainsKey('RatingTo'))){
    $ratingTo = 10000
}

if ($Path.Length -eq 0){
    $Path = "." #if Path was not entered, set it as the current folder
}

#main part of script

if ($MyInvocation.ExpectingInput){ #we are getting values from pipe
    foreach ($file in $input){
        $Rating = .\Get-PhotoRating $file.FullName
        if ( ($Rating -le $ratingTo) -and ($Rating -ge $ratingFrom)){
            Write-Output $file  
            Write-Host $file " ---> RATING: " $Rating
        }
    }
}

else{
    $photos = Get-ChildItem -Path $Path -Filter $Filter
    foreach ($file in $photos) {
        #$Photo = "$env:UserProfile\Pictures\upravene2021\baltik2021\IMG_6241.JPG"
        #Write-Host "Processing: " $file.FullName
        $Rating = .\Get-PhotoRating $file.FullName
        
        if ( ($Rating -le $ratingTo) -and ($Rating -ge $ratingFrom)){
            Write-Output $file  
            Write-Host $file " ---> RATING: " $Rating
        }
    }
}



#Write-Host $Photo 
#Write-Host Rating: $ImgFile.ImageTag.Rating