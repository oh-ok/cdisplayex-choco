$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'CDisplayExWin32v1.10.33.exe'
$fileLocation64 = Join-Path $toolsDir 'CDisplayExWin64v1.10.33.exe'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  file         = $fileLocation
  file64    = $fileLocation64

  softwareName  = 'cdisplayex*'
  checksum      = '3777afbc649901be6948bcd22f97f1c1d0f77c6375f5a027a88a62a75e5eecda'
  checksumType  = 'sha256'
  checksum64    = '38352a6240b3407b43c6b21d70d0ec5fca12592ab68b869cbfa9a8efc8d36cff'
  checksumType64= 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs