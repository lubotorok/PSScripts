#Skript vyzaduje pristup ku WinSCP .dll kniznici a WinSCP.exe, oboje musi byt
#stiahnute zo stranky WinSCP, vola sa to WinSCP Dot Net Assembly. Oba subory musia
#byt v jednom adresari, cesta ku adresaru sa nastavuje v skripte.

Param(
    [string]$ftphost,       #adresa ftp servera, napr. "ftp.test.sk"
    [string]$login,         #prihlasovacie meno na ftp (heslo si pyta po spusteni)
    [string]$dirlist        #textovy .csv subor so zoznamom parov adresarov na porovnanie
)

$pwd = Read-Host -assecurestring "Heslo"
$pwd = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd))

#Nacitanie lokalnych a vzdialenych adresarov na porovnanie
$dirsToDiff = Import-Csv -Header ('Lokalny', 'Vzdialeny') $dirlist
Write-Host "Overujem adresare: "
Write-Host $dirsToDiff

try
{
    # Nastavenia
    
    #WinSCP Dot Net assembly umiestnenie
    $WinSCPDotNetLoc = "C:\tools\winscp_dotnet"


    $DllLoc = $WinSCPDotNetLoc + "\WinSCPnet.dll"
    
    Add-Type -Path $DllLoc

     
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Ftp
        HostName = $ftphost
        UserName = $login
        Password = $pwd
        #SshHostKeyFingerprint = "ssh-rsa 2048 xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
    }
 
    $session = New-Object WinSCP.Session
    $session.ExecutablePath = $WinSCPDotNetLoc + "\WinSCP.exe"
 
    try
    {
        # Connect
        $session.Open($sessionOptions)

        foreach ($dirPair in $dirsToDiff){
            $remote = $session.ListDirectory($dirPair.Remote)
            $lokal = Get-ChildItem($dirPair.Lokal)
            # TODO: porovnanie jednotlivych suborov ...
                   foreach ($fileInfo in $remote.Files)
                   {
                       Write-Host ("$($fileInfo.Name) with size $($fileInfo.Length), " +
                           "permissions $($fileInfo.FilePermissions) and " +
                           "last modification at $($fileInfo.LastWriteTime)")
                   }
        }
 
        
    }
    finally
    {
        # Disconnect, clean up
        $session.Dispose()
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}
