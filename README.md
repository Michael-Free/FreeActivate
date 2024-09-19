# FreeActivate
A Powershell module to activate Volume Licensed Windows Desktop and Windows Server OS on the command line.

## Description

## Features

## Installation
Installing FreeActivate from the Powershell Gallery:
  - ```Install-Module -Name FreeActivate```

## Usage
Importing the FreeActivate Module:
  - ```Import-Module -Name FreeActivate```

Getting the Activation status of the device:
  - ```Get-Activation```

Activating with a KMS Key:
  - ```Set-KmsActivation -Server <FQDN/IP Address> -Key XXXXX-XXXXX-XXXXX-XXXXX-XXXXX```

Activating with a MAK Key:
  - ```Set-MakActivation -Key XXXXX-XXXXX-XXXXX-XXXXX-XXXXX```

## Requirements
- Windows 10+
- Windows Server 2016+
- Powershell v5.1+

## License
MIT License
License Information can be found [HERE](https://github.com/Michael-Free/FreeActivate/blob/main/LICENSE).

## Author
Michael Free
