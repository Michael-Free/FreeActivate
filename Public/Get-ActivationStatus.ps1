function Get-ActivationStatus {
  <#
  .SYNOPSIS
  Retrieves Windows activation status using the Software Licensing Management Tool (slmgr.vbs).

  .DESCRIPTION
  The Get-ActivationStatus function executes the Software Licensing Management Tool (slmgr.vbs)
  to retrieve detailed license information for the local Windows installation. It specifically
  extracts the license status from the output and returns it as a custom object.

  .PARAMETER None
  This function does not accept any parameters. It queries the local system's activation status.

  .INPUTS
  None. This function does not accept pipeline input.

  .OUTPUTS
  PSCustomObject
  Returns a custom object with a LicenseStatus property containing the Windows activation status.

  .EXAMPLE
  PS C:\> Get-ActivationStatus

  LicenseStatus
  -------------
  Licensed

  Description: Retrieves the activation status of the local Windows installation.

  .EXAMPLE
  PS C:\> $status = Get-ActivationStatus
  PS C:\> Write-Host "Windows is: $($status.LicenseStatus)"

  Windows is: Licensed

  Description: Stores the activation status in a variable and displays it.

  .NOTES
  Author: Michael Free
  Date Created: January 29, 2026
  Prerequisites:
  - Must be run with administrative privileges
  - Requires slmgr.vbs to be available (default Windows component)
  - Only works on Windows systems with Software Licensing service

  The function executes: cscript.exe /NoLogo $script:slmgrPath /dlv
  Where $script:slmgrPath should be defined elsewhere in the script/module.

  Common License Status values:
  - Licensed: Product is activated
  - Initial grace period: Evaluation period
  - Licensed (expired): Activation has expired
  - Notification: Grace period expired, notifications active
  #>
  $licenseInfo = (cscript.exe /NoLogo $script:slmgrPath /dlv) -split "`n"
  $licenseStatus = $licenseInfo | ForEach-Object {
    if ($_ -like '*License Status*') {
      $_ -replace '.*License Status: ', ''
    }
  }
  $licenseObject = [pscustomobject]@{
    LicenseStatus = $licenseStatus
  }
  return $licenseObject
}

