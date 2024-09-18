# FreeActivate.psm1
function Get-Activation() {
  $licenseStatus = (cscript.exe /nologo C:\Windows\System32\slmgr.vbs /dlv) -Split "`n" | ForEach-Object {
    if ($_ -like "*License Status*") {
      $_ -replace ".*License Status: ", ""
    }
  }
  # Create a Custom Object Here to Return
}

function Set-KmsActivation() {
  Write-Output "KMS Activation"
}

function Set-MakActivation() {
  Write-Output "MAK Activation"
}
