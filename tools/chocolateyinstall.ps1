$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$osBits = Get-ProcessorBits
if ($Env:ChocolateyForceX86) {
  $osBits = "32"
}


# Grabs the latest setup files from the official website
# - Can't use Get-ChocolateyWebFile because we need the -Method Post
function Get-SetupExe($bitStr) {
  $options = @{ "os"="win"+ $bitStr }
  $fName = "CDisplayExWin" + $bitStr + "v" + $version + ".exe"
  $fPath = Join-Path $toolsDir $fName
  $baseUrl = "http://www.cdisplayex.com/findit.php"

  Write-Host "Grabbing latest $bitStr-bit installer from http://www.cdisplayex.com/..."
  $response = Invoke-WebRequest -Uri $baseUrl -Method Post -Body $options -OutFile "$toolsDir/temp.exe" -PassThru
  $testResponse = $response.Headers["Content-Disposition"] -match '(CDisplayEx.*\.exe)'
  if ($testResponse) { # Did we download an installer?
    if ($Matches.0 -eq $fName) { # Make sure it matches the expected above
      Move-Item -Path "$toolsDir/temp.exe" -Destination $fPath # Rename to be it's original downlaoded filename
      return $fPath
    } else { # Got an installer but the file names are mismatched
      Throw [System.IO.FileNotFoundException] "This version is out of date and no longer available to download from official sources - sorry about that!"
    }
  } else { # Got a reponse but no installer
    Throw [System.IO.FileNotFoundException] "Could not download the CDisplayEx setup file, maybe you're trying to download a version no longer publicly available - sorry about that!"
  }
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  file          = Get-SetupExe $osBits

  softwareName  = 'cdisplayex*'
  checksum      = '3777afbc649901be6948bcd22f97f1c1d0f77c6375f5a027a88a62a75e5eecda'
  checksumType  = 'sha256'
  checksum64    = '38352a6240b3407b43c6b21d70d0ec5fca12592ab68b869cbfa9a8efc8d36cff'
  checksumType64= 'sha256'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs