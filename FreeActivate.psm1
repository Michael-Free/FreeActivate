# FreeActivate.psm1
function Get-Activation() {
  $licenseInfo = (cscript.exe /nologo C:\Windows\System32\slmgr.vbs /dlv) -Split "`n"
  $licenseStatus = $licenseInfo | ForEach-Object { 
    if ($_ -like "*License Status*") {
      $_ -replace ".*License Status: ", "" 
    }
  }
  $licenseObject = [pscustomobject]@{
    LicenseStatus = $licenseStatus
  }
  return $licenseObject
}

#function Set-KmsActivation() {
#  Write-Output "KMS Activation"
#}

#function Set-MakActivation() {
#  Write-Output "MAK Activation"
#}
