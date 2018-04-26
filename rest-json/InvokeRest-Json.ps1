<#
This script calls a rest service determined by the URI
parameter and writes out the json response from it.
#>
param (
    [string]$uri
)

$R = Invoke-RestMethod -uri $uri
$JSon = ConvertTo-Json -depth 100 $R

Write-Host $JSon