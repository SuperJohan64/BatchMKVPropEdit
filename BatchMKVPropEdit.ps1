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

function Set-MkvTrackFlags {
    $track = Read-Host "`n********************************`n`nSelect track.`n`nFor subtitle tracks use s1, s2, s3 etc.`nFor audio tracks use a1, a2, a3, etc`n`nEnter your track"
        $enableOrDisable = Read-Host "`n********************************`n`nSelect an option.`n`n0. Disable Track`n1. Enable Track`n`nEnter 0 or 1"
        $setDefaultTrack = Read-Host "`n********************************`n`nSelect an option.`n`n0. Remove default flag on track`n1. Enable default flag on track`n`nEnter 0 or 1"
        $forceTrack = Read-Host "`n********************************`n`nForce this track?`n`n0. No`n1. Yes`n`nEnter 0 or 1"

        foreach ($file in (Get-ChildItem -LiteralPath $sourceDir -Include *.mkv -Recurse).FullName) {
            Write-Host `n$file
            & $mkvpropedit $file `
                -d title `
                --edit track:$track --set flag-enabled=$enableOrDisable `
                --edit track:$track --set flag-default=$setDefaultTrack `
                --edit track:$track --set flag-forced=$forceTrack
        }
}

function Set-MkvTrackLanguage {
    $track = Read-Host "`n********************************`n`nSelect track.`n`nFor subtitle tracks use s1, s2, s3 etc.`nFor audio tracks use a1, a2, a3, etc`n`nEnter your track"
    $language = Read-Host "`n********************************`n`nEnter the track 3 digit language code (eg eng or jpn)"

    foreach ($file in (Get-ChildItem -LiteralPath $sourceDir -Include *.mkv -Recurse).FullName) {
        Write-Host `n$file
        & $mkvpropedit $file --edit track:$track --set language=$language
    }
}

function Remove-MkvTitleMetaData {
    foreach ($file in (Get-ChildItem -LiteralPath $sourceDir -Include *.mkv -Recurse).FullName) {
        Write-Host `n$file
        & $mkvpropedit $file -d title `
    }
}

$sourceDir = Read-Host "`nEnter the path to the source file or directory"
$sourceDir = $sourceDir.Replace("`"","")

Write-Host "`nChoose a mode."
Write-Host "`n1. Set MKV trak's default, forced, and enabled flags. This options also removes the MKV title meta data`n2. Set MKV tracks language`n3. Remove MKV title metadata`n"
$scriptMode = Read-Host "Enter 1, 2, or 3"

switch ($scriptMode) {
    1 {Set-MkvTrackFlags}
    2 {Set-MkvTrackLanguage}
    3 {Remove-MkvTitleMetaData}
}