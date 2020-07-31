$xml = "$PSScriptRoot\MKVPropEditGUI.xml"
if (!(Test-Path $xml)) {
    $mkvpropedit = Read-Host "`nEnter the local path to mkvpropedit.exe"
    $mkvpropedit | Export-Clixml $xml
}

$mediaSource = Read-Host "`nEnter the path to the source file or directory"
$mediaSource = $mediaSource.Replace("`"","")

$track = Read-Host "`n********************************`n`nSelect track.`n`nFor subtitle tracks use s1, s2, s3 etc.`nFor audio tracks use a1, a2, a3, etc`n`nEnter your track"
$language = Read-Host "`n********************************`n`nEnter the track 3 digit language code (eg eng or jpn)"
$enableOrDisable = Read-Host "`n********************************`n`nSelect an option.`n`n0. Disable Track`n1. Enable Track`n`nEnter 0 or 1"
$force = Read-Host "`n********************************`n`nSet this track as the default?`n`n0. No`n1. Yes`n`nEnter 0 or 1"

foreach ($file in (Get-ChildItem -LiteralPath $mediaSource -Recurse).FullName) {
    Write-Host `n$file
    & $mkvpropedit $file `
        --edit track:$track --set language=$language `
        --edit track:$track --set flag-default=$enableOrDisable `
        --edit track:$track --set flag-forced=$force
}