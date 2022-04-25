$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# This downloads the relevant exe from the official source.
$options32 = @{  "os"="win32" }
$options64 = @{  "os"="win64" }
$baseUrl = "http://www.cdisplayex.com/findit.php"

if ([Environment]::Is64BitOperatingSystem) {
  "Downloading 64bit installer"
  Invoke-WebRequest -Uri $baseUrl -Method Post -Body $options64 -OutFile "$toolsDir/CDisplayExWin64v$version.exe"
} else {
  "Downloading 32bit installer"
  Invoke-WebRequest -Uri $baseUrl -Method Post -Body $options32 -OutFile "$toolsDir/CDisplayExWin32v$version.exe"
}

$fileLoc = "CDisplayExWin32v$version.exe"
$fileLoc64 = "CDisplayExWin64v$version.exe"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  file          = Join-Path $toolsDir $fileLoc
  file64        = Join-Path $toolsDir $fileLoc64

  softwareName  = 'cdisplayex*'
  checksum      = '3777afbc649901be6948bcd22f97f1c1d0f77c6375f5a027a88a62a75e5eecda'
  checksumType  = 'sha256'
  checksum64    = '38352a6240b3407b43c6b21d70d0ec5fca12592ab68b869cbfa9a8efc8d36cff'
  checksumType64= 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs