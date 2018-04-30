<#
.SYNOPSIS
Compares two xml files by elements expaths and writes out the differences.

.DESCRIPTION
Compares two given XML files by their XML elements structure.

.EXAMPLE
xml-compare file1.xml file2.xml
Compares file1.xml (LEFT) and file2 (RIGHT) and shows the differences
such that first are shown the xpaths occuring in the LEFT file and then 
the xpaths which occur in the right file onnly.

.NOTES
    AUTHOR: Lubo Torok
    COPYRIGHT: 2018 by Lubo Torok

#>

[xml]$leftXml = Get-Content $args[0]
$leftName = $args[0]

[xml]$rightXml = Get-Content $args[1]
$rightName = $args[1]


function Get-XPath($n) {
  #Write-Host ("Getting xpath for " + $n.Name +", parent = " + $n.ParentNode.Name)
  if ( ( $n.GetType().Name -ne 'XmlDocument' ) -and ( $n.ParentNode -ne $null) ) {
    "{0}/{1}" -f (Get-XPath $n.ParentNode), $n.Name
  }
}


Write-Host "Comparing LEFT = $leftName"
Write-host "with RIGHT = $rightName"
Write-Host "-------------------"

#$leftXml.SelectNodes("asas").Item(1).

$leftNodes = $leftXml.SelectNodes("//*")
$leftPaths = @()
$leftCount = $leftNodes.Count
$i=0

$rightNodes = $rightXml.SelectNodes("//*")
$rightPaths = @()
$rightCount = $rightNodes.Count
$j=0

foreach ($node in $leftnodes){
  $leftPaths += Get-XPath($node)
  Write-Progress -Activity "Collecting LEFT xpaths" -Status "XPath $i from $leftCount" -PercentComplete (($i/$leftCount) * 100)
  $i++
}
$leftPaths = $leftPaths | Sort-Object 

foreach ($node in $rightNodes){
  $rightPaths += Get-XPath($node)
  Write-Progress -Activity "Collecting RIGHT xpaths" -Status "XPath $j from $rightCount" -PercentComplete (($j/$rightCount) * 100)
  $j++
}
$rightPaths = $rightPaths | Sort-Object

$docDiffs=Compare-Object $leftPaths $rightPaths
$docDiffCount = $docDiffs.Count
$k = 0

$leftVystup = ""
$rightVystup = ""

foreach( $diff in $docDiffs){
 
  if ($diff.SideIndicator -eq "<=" ) { 
      $leftVystup = $leftVystup + "Element: " + $diff.InputObject +" occurs in LEFT file only `n"
  }
  else {
      $rightVystup = $rightVystup + "   Element: " + $diff.InputObject +" occurs in RIGHT file only `n";
  }
  
  Write-Progress -Activity "Processing diffs" -Status "Diff $k from $docDiffCount" -PercentComplete (($k/$docDiffCount) * 100)
  $k++
}

Write-Host "------ LEFT occurences only --------"
Write-Host $leftVystup
Write-Host "-------RIGHT occurences only--------"
Write-Host $rightVystup
Write-Host "--- END ---"
