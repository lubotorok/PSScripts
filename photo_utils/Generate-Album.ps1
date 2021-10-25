<#
    Command creates a simple HTML page showinf images from input listing as string, which can 
    further processed - either saved to a file or sent to other command via pipe.

    .PARAMETER <width>
    Fixed width of pictures. Default is 900px if ommitted.

    .PARAMETER <height>
    Fixed height of pictures. Default is 600px if ommitted.


    .NOTES
    AUTHOR Lubo Torok
    COPYRIGHT: 2021 Lubo Torok
#>

param([int]$width, [int]$height)

$htmlHeader="<html><body><div align=`"center`">"
$htmlFooter="</div></body></html>"
$html=$htmlHeader

if (!($PSBoundParameters.ContainsKey('width')))
{
    $width=900
}
if (!($PSBoundParameters.ContainsKey('height'))){
    $height=600
}

if ($MyInvocation.ExpectingInput){
    foreach($file in $input){
        $img = "<img src=`""+$file.FullName+"`" width=`"$width`" height=`"$height`" /><br/>"
	$img = $img + $file.FullName + "<br/><br/>"
        $html = $html + $img
    }
}

$html = $html + $htmlFooter
Write-Output $html

