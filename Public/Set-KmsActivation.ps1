function Set-KmsActivation {
  <#
  .SYNOPSIS
  Configures and activates Windows using a KMS (Key Management Service) server.

  .DESCRIPTION
  The Set-KmsActivation function configures Windows volume licensing by setting a KMS server,
  installing a product key, and activating Windows. It performs comprehensive validation
  including network connectivity checks, administrator privilege verification, and parameter
  format validation before attempting activation.

  .PARAMETER Server
  Specifies the KMS server address. Must be a valid IPv4 address or FQDN (Fully Qualified Domain Name).
  The server must be reachable and have port 1688 open for KMS activation.

  .PARAMETER Key
  Specifies the Windows product key for activation. Must be in the standard 5x5 format
  (AAAAA-BBBBB-CCCCC-DDDDD-EEEEE). The key will be converted to uppercase automatically.

  .INPUTS
  None. This function does not accept pipeline input.

  .OUTPUTS
  PSCustomObject
  Returns the activation status from the Get-Activation function after successful configuration.

  .EXAMPLE
  PS C:\> Set-KmsActivation -Server "kms01.company.com" -Key "XXXXX-YYYYY-ZZZZZ-WWWWW-VVVVV"

  Description: Configures Windows to use kms01.company.com as the KMS server with the specified product key.

  .EXAMPLE
  PS C:\> Set-KmsActivation -Server "192.168.1.100" -Key "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE" -Confirm:$false

  Description: Configures Windows to use a KMS server at 192.168.1.100 without confirmation prompt.

  .EXAMPLE
  PS C:\> Set-KmsActivation -Server "kms.company.local" -Key "12345-ABCDE-67890-FGHIJ-12345" -WhatIf

  Description: Shows what would happen without actually making changes (WhatIf scenario).

  .NOTES
  Author: Michael Free
  Date Created: January 29, 2026
  Prerequisites:
  - Must be run with administrative privileges
  - Requires slmgr.vbs to be available (default Windows component)
  - KMS server must be reachable and have port 1688 open
  - Server must be a valid IPv4 address or FQDN
  - Key must be in valid Windows product key format

  What the function does:
  1. Validates administrator privileges
  2. Removes spaces from Server and Key parameters
  3. Validates parameter formats (IP/FQDN for Server, product key format for Key)
  4. Tests network connectivity to KMS server (ICMP and TCP port 1688)
  5. Executes slmgr.vbs commands with ShouldProcess support:
     - /ipk: Installs the product key
     - /skms: Sets the KMS server address
     - /ato: Activates Windows online
  6. Returns activation status using Get-Activation

  Security: This function requires elevated privileges and modifies system licensing settings.
  Use with caution in production environments.
  #>
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  param(
    [Parameter(Mandatory = $true)]
    [string]$Server,
    [Parameter(Mandatory = $true)]
    [string]$Key
  )

  $Server.Replace(' ', '')
  $Key.Replace(' ', '')

  $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal($currentUser)
  $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

  if (-not $isAdmin) {
    throw 'This command requires administrative privileges'
  }

  if ([string]::IsNullOrEmpty($Server) -or [string]::IsNullOrEmpty($Key)) {
    throw 'Key and Server parameters cannot be empty or have a null value.'
  }

  if ($Server -notmatch $script:ipRegex -and $Server -notmatch $script:fqdnRegex) {
    throw 'Server parameter does not match IP or FQDN format'
  }

  if ($Key -notmatch $script:windowsKeyRegex) {
    throw 'Incorrect Windows Key Format'
  }

  if (-not (Test-Connection -ComputerName $Server -Count 2 -Quiet)) {
    throw 'No route to KMS Server'
  }

  if (-not (Test-NetConnection -ComputerName $Server -Port 1688)) {
    throw 'Port 1688 not open on KMS Server'
  }

  $activationKey = $Key.ToUpper()

  if ($PSCmdlet.ShouldProcess('KMS Server Configuration', "Set KMS Server to $Server and install activation key $Key")) {
    try {
      cscript.exe /NoLogo $script:slmgrPath /ipk $activationKey
      if ($LASTEXITCODE -ne 0) {
        throw "Error installing product key. Exit Code: $LASTEXITCODE"
      }
      cscript.exe /NoLogo $script:slmgrPath /skms $Server
      if ($LASTEXITCODE -ne 0) {
        throw "Error setting KMS Server. Exit Code: $LASTEXITCODE"
      }
      cscript.exe /NoLogo $script:slmgrPath /ato
      if ($LASTEXITCODE -ne 0) {
        throw "Error activating Windows. Exit Code: $LASTEXITCODE"
      }
      $activationStatus = Get-Activation
      return $activationStatus
    }
    catch {
      throw "Error during licensing operation: $_"
    }
  }
}


