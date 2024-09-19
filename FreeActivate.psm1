# FreeActivate.psm1

$ipRegex = '^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$'
$fqdnRegex = '^(?=.{1,255}$)([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$'
$windowsKeyRegex = '^[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}$'
$slmgrPath = Join-Path -Path $env:SystemRoot -ChildPath "System32\slmgr.vbs"

function Get-Activation() {
  $licenseInfo = (cscript.exe /NoLogo $script:slmgrPath /dlv) -Split "`n"
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

  $Server.Replace(' ', '')
  $Key.Replace(' ', '')

  $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
  $currentPrincipal = new-object Security.Principal.WindowsPrincipal($currentUser)
  $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

  if (-not $isAdmin) {
    throw "This command requires administrative privileges"
  }

  if ([string]::IsNullOrEmpty($Server) -or [string]::IsNullOrEmpty($Key)) {
    throw "Key and Server parameters cannot be empty or have a null value."
  }

  if ($Server -notmatch $script:ipRegex -and $Server -notmatch $script:fqdnRegex) {
    throw "Server parameter does not match IP or FQDN format"
  }

  if ($Key -notmatch $script:windowsKeyRegex) {
    throw "Incorrect Windows Key Format"
  }

  $activationKey = $Key.ToUpper()

  try {
    cscript.exe /NoLogo $script:slmgrPath /ipk $activationKey
    if ($LASTEXITCODE -ne 0) {
      throw "Error installing product key. Exit Code: $LASTEXITCODE"
    }
  } catch {
    throw "Error installing product key: $_"
  }

  try {
    cscript.exe /NoLogo $script:slmgrPath /skms $Server
    if ($LASTEXITCODE -ne 0) {
      throw "Error setting KMS Server. Exit code: $LASTEXITCODE"
    }
  } catch {
    throw "Error setting KMS Server: $_"
  }

  try {
    cscript.exe /NoLogo $script:slmgrPath /ato
    if ($LASTEXITCODE -ne 0) {
      throw "Error Activating Windows. Exit code: $LASTEXITCODE"
    }
  } catch {
    throw "Error Activating Windows: $_"
  }
}

#function Set-MakActivation() {
#  Write-Output "MAK Activation"
#}
