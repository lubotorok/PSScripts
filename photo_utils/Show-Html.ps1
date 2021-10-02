using namespace System.Windows.Forms
using namespace System.Drawing

param(
    [string]$htmlSource
)

# Load the WinForms assembly.
Add-Type -AssemblyName System.Windows.Forms

if ($htmlSource.Length -eq 0){
    write-host "Idem z pipe"
    $htmlSource = $input #podstrcime mu vstup z pipe 
}
elseif ($args.Count -gt 1){
    Write-Host "Usage: show-html <htmlSource>"
    Write-Host "<command> | show-html"
}
# Create a form.
$form = [Form] @{
    ClientSize      = [Point]::new(1820, 1000)
    Text            = "WebBrowser-Control Demo"
}

# Create a web-browser control, make it as large as the inside of the form,
# and assign the HTML text.
$sb = [WebBrowser] @{
  ClientSize = $form.ClientSize
  DocumentText = $htmlSource
}

# Add the web-browser control to the form...
$form.Controls.Add($sb)

# ... and display the form as a dialog (synchronously).
$form.ShowDialog()

# Clean up.
$form.Dispose()