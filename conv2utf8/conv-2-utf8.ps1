$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
$W1250Encoding =  [Text.Encoding]::GetEncoding("windows-1250")

$source = $args[0]
$destination = $args[1]
$filter = $args[2]

if ($args.Count -ne 3){
    Write-Host "Usage: conv-2-utf8.ps1 <srcdir> <destdir> <filter>"
    exit 1
}

Write-Host "Encoding to UTF8..."
Write-Host "   source directory> $source"
Write-Host "   destination directory> $destination."

foreach ($i in Get-ChildItem $source -Recurse -Force -Filter $filter) {
    if ($i.PSIsContainer) {
        continue
    }

    
    $path = $i.Directory.Fullname.replace($source, $destination)
    $name = $i.Fullname.replace($source, $destination)

    Write-Host "Path = $path"
    Write-Host "Name = $name"

    if ( !(Test-Path $path) ) {
        New-Item -Path $path -ItemType directory
    }
   
    $content = [System.IO.File]::ReadAllLines($i.Fullname, $W1250Encoding)
    
    if ( $content -ne $null ) {
        Write-Host "Writing: $name"
        [System.IO.File]::WriteAllLines($name, $content, $Utf8NoBomEncoding)
    } else {
        Write-Host "No content from: $i"   
    }
}

Write-Host "Done."
