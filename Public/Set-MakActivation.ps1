function Set-MakActivation {
  <#
  .SYNOPSIS
  Activates Windows using a MAK (Multiple Activation Key) for volume licensing.

  .DESCRIPTION
  The Set-MakActivation function installs and activates a Multiple Activation Key (MAK)
  for Windows volume licensing. This method is used for one-time activation directly
  with Microsoft's activation servers, as opposed to KMS (Key Management Service)
  which requires an on-premises server. The function validates the key format and
  requires administrative privileges.

  .PARAMETER Key
  Specifies the Windows Multiple Activation Key (MAK). Must be in the standard 5x5 format
  (AAAAA-BBBBB-CCCCC-DDDDD-EEEEE). The key will be converted to uppercase automatically.

  .INPUTS
  None. This function does not accept pipeline input.

  .OUTPUTS
  PSCustomObject
  Returns the activation status from the Get-Activation function after successful activation.

  .EXAMPLE
  PS C:\> Set-MakActivation -Key "XXXXX-YYYYY-ZZZZZ-WWWWW-VVVVV"

  Description: Installs and activates the specified MAK key on the local Windows installation.

  .EXAMPLE
  PS C:\> Set-MakActivation -Key "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE" -Confirm:$false

  Description: Activates Windows with the specified MAK key without confirmation prompt.

  .EXAMPLE
  PS C:\> Set-MakActivation -Key "12345-ABCDE-67890-FGHIJ-12345" -WhatIf

  Description: Shows what would happen without actually making changes (WhatIf scenario).

  .NOTES
  Author: Michael Free
  Date Created: January 29, 2026
  Prerequisites:
  - Must be run with administrative privileges
  - Requires slmgr.vbs to be available (default Windows component)
  - Key must be in valid Windows product key format
  - Internet connectivity is required for MAK activation
  - The MAK key must have available activations

  What the function does:
  1. Validates administrator privileges
  2. Removes spaces from the Key parameter
  3. Validates the key format against the Windows key regex pattern
  4. Converts the key to uppercase
  5. Executes slmgr.vbs commands with ShouldProcess support:
     - /ipk: Installs the product key
     - /ato: Activates Windows online via Microsoft servers
  6. Returns activation status using Get-Activation

  MAK vs KMS Activation:
  - MAK: One-time activation directly with Microsoft, suitable for devices that cannot
    connect to a KMS server regularly
  - KMS: Requires connection to a local KMS server every 180 days, suitable for large
    enterprise environments with on-premises infrastructure

  Security: This function requires elevated privileges and modifies system licensing settings.
  Use with caution in production environments.
  #>
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  param(
    [Parameter(Mandatory = $true)]
    [string]$Key
  )

  $Key.Replace(' ', '')

  $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal($currentUser)
  $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

  if (-not $isAdmin) {
    throw 'This command requires administrative privileges'
  }

  if ([string]::IsNullOrEmpty($Key)) {
    throw 'Key parameter cannot be empty or have a null value.'
  }

  if ($Key -notmatch $script:windowsKeyRegex) {
    throw 'Incorrect Windows Key Format'
  }

  $activationKey = $Key.ToUpper()

  if ($PSCmdlet.ShouldProcess('Install Multiple Activation Key', "Set MAK Key and install activation key $Key")) {
    try {
      cscript.exe /NoLogo $script:slmgrPath /ipk $activationKey
      if ($LASTEXITCODE -ne 0) {
        throw "Error installing product key. Exit Code: $LASTEXITCODE"
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

