# FreeActivate.psm1

$ipRegex = '^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$'
$fqdnRegex = '^(?=.{1,255}$)([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$'
$windowsKeyRegex = '^[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}$'

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
    throw "-Key or -Server parameters cannot be empty or have a null value."
  }

}

#function Set-MakActivation() {
#  Write-Output "MAK Activation"
#}
