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

function Set-KmsActivation() {
  param(
    [Parameter(Mandatory=$true)]
    [string]$Server,
    [Parameter(Mandatory=$true)]
    [string]$Key
  )

  $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
  $currentPrincipal = new-object Security.Principal.WindowsPrincipal($currentUser)
  $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

  if (-not $isAdmin) {
    throw "This command requires administrative privileges"
  }

  if ([string]::IsNullOrEmpty($Server) -or [string]::IsNullOrEmpty($Key)) {
    throw "-Key or -Server flag cannot be empty or have a null value."
  }

}

#function Set-MakActivation() {
#  Write-Output "MAK Activation"
#}
