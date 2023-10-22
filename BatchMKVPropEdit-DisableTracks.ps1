if (Test-Path "$PSScriptRoot\mkvpropedit.exe") {
    $mkvpropedit = "$PSScriptRoot\mkvpropedit.exe"
}
else {
    if (Test-Path "$env:ProgramFiles\MKVToolNix\mkvpropedit.exe") {
        $mkvpropedit = "$env:ProgramFiles\MKVToolNix\mkvpropedit.exe"
    }
    else {
        Write-Host "No mkvpropedit found. Please make sure mkvpropedit.exe is installed or saved to the same directory as this script."
        Exit
    }
}
Write-Host "mkvpropedit.exe found in $mkvpropedit"

$sourceDir = Read-Host "`nEnter the path to the source file or directory"
$sourceDir = $sourceDir.Replace("`"","")

$track = Read-Host "`n********************************`n`nSelect track.`n`nFor subtitle tracks use s1, s2, s3 etc.`nFor audio tracks use a1, a2, a3, etc`n`nEnter your track"
$enableOrDisable = Read-Host "`n********************************`n`nSelect an option.`n`n0. Disable Track`n1. Enable Track`n`nEnter 0 or 1"

foreach ($file in (Get-ChildItem -LiteralPath $sourceDir -Include *.mkv -Recurse).FullName) {
    Write-Host `n$file
    & $mkvpropedit $file `
        -d title `
        --edit track:$track --set flag-enabled=$enableOrDisable `
}