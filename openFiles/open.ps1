#pouzitie open [aplikacia] [-verbose] [filter][<filter>]...
#alebo [subory na otvorenie] | open [-verbose] [aplikacia]
#subory v danom adresari splnajuce filtrovacie kriteria 
#otvori aplikaciou [aplikacia], za predpokladu ze to ta aplikacia zvladne.

#priklad 1: "open pspad *.log *.txt" otvori vsetky log a txt subory z aktualneho adresara

#priklad 2: " get-childeitem -filter *.txt|open pspad" cez pipe nastrka vystup predosleho
#prikazu ako argumenty pre zadanu aplikaciu.
#Prepinac -verbose zapne vystup na obrazovku s vypisom nazvu pouzitej aplikacie a 
#argumentov ktore dostala. 

#prioritne sa pozera na argumenty za [aplikacia] ak tam ziadne nie su, predpoklada ze vstup 
#ide cez pipe


<#
.SYNOPSIS
Opens an application with arguments consisting of set of files.

.DESCRIPTION
Opens an application with arguments consisting of set of files 
which come either from a pipe or which satisfy
given one or more regular expression filters.

.PARAMETER <filter>
Any regular expression filter

.EXAMPLE
open pspad *.log *.txt
Opens all files satisfying filters *.log and *.txt in application 
"pspad".

.EXAMPLE
get-childitem -filter *2012-05-14.log|open pspad
Finds all files in current directory with names satisfying filter
"*2012-05-14.log" and opens them in "pspad" application. In this 
case opens all logs from day 2012-05-14.


#>
param([switch]$verbose)
$fls = @( ) #prazdne pole, jediny sposob, ako vygenerovat dynamicky paramtre je dat ich do pola 
            #(inak to vezme cely string ako 1 parameter)
if ($args.count -gt 1){
    for ($i=1;$i -lt $args.count; $i++){
        $files = get-childitem -filter $args[$i]
        foreach($file in $files){
            $fls = $fls + $file
        }
    }
}
else{ #vstup z pipe
    foreach($file in $input){
        $fls = $fls + $file
    }
}
if ($verbose){
    write-host "Opening"
    write-host "   "$args[0] -ForegroundColor "green"
    write-host "with arguments: "
    foreach($f in $fls){
        write-host "    $f" -ForegroundColor "green"
    }
}

&$args[0] $fls

