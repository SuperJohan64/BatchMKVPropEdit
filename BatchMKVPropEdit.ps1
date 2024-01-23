# MKVToolNix/mkvpropedit.exe download - https://mkvtoolnix.download/downloads.html
# mkvpropedit.exe documentation -  https://mkvtoolnix.download/doc/mkvpropedit.html
# ISO 639-2 codes for track languages - https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes

if (Test-Path "$PSScriptRoot\mkvpropedit.exe") {
    $mkvpropedit = "$PSScriptRoot\mkvpropedit.exe"
}
else {
    if (Test-Path "$env:ProgramFiles\MKVToolNix\mkvpropedit.exe") {
        $mkvpropedit = "$env:ProgramFiles\MKVToolNix\mkvpropedit.exe"
    }
    else {
        Write-Host "mkvpropedit.exe not found.`n`nDownload and install MKVToolNix from the following URL - https://mkvtoolnix.download/downloads.html.`n`nThis script will now close.`n"
        PAUSE
        Exit
    }
}
Write-Host "mkvpropedit.exe found in $mkvpropedit"

function Set-MkvTrackFlags {
    $track = Read-Host "`n********************************`n`nSelect track.`n`nFor subtitle tracks use s1, s2, s3 etc.`nFor audio tracks use a1, a2, a3, etc`n`nEnter your track"
    $enableOrDisable = Read-Host "`n********************************`n`nSelect an option.`n`n0. Disable Track`n1. Enable Track`n`nEnter 0 or 1"
    $setDefaultTrack = Read-Host "`n********************************`n`nSelect an option.`n`n0. Remove default flag on track`n1. Enable default flag on track`n`nEnter 0 or 1"
    $forceTrack = Read-Host "`n********************************`n`nForce this track?`n`n0. No`n1. Yes`n`nEnter 0 or 1"

    foreach ($file in $sourceFiles) {
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
    $language = Read-Host "`n********************************`n`nEnter the track 3 digit language code (eg eng, jpn, or und (undetermined) )"

    foreach ($file in $sourceFiles) {
        Write-Host `n$file
        & $mkvpropedit $file --edit track:$track --set language=$language
    }
}

function Set-MkvTrackName {
    $track = Read-Host "`n********************************`n`nSelect track.`n`nFor subtitle tracks use s1, s2, s3 etc.`nFor audio tracks use a1, a2, a3, etc`n`nEnter your track"
    $name = Read-Host "`n********************************`n`nEnter MKV track's name"

    foreach ($file in $sourceFiles) {
        Write-Host `n$file
        & $mkvpropedit $file --edit track:$track --set name=$name
    }
}

function Remove-MkvTitleMetaData {
    foreach ($file in $sourceFiles) {
        Write-Host `n$file
        & $mkvpropedit $file -d title `
    }
}

while ($true) {
    $sourceFiles = Read-Host "`nEnter the path to the source file or directory"
    $sourceFiles = $sourceFiles.Replace("`"", "")
    $sourceFiles = (Get-ChildItem -LiteralPath $sourceFiles -Include *.mkv -Recurse).FullName

    Write-Host "`nChoose a mode."
    Write-Host "`n1. Set MKV track's default, forced, enabled flags, and remove MKV title data.`n2. Set MKV tracks language.`n3. Set MKV track's name.`n4. Remove MKV title metadata`n5. Exit Script"
    $scriptMode = Read-Host "`nEnter an option 1-5"

    switch ($scriptMode) {
        1 { Set-MkvTrackFlags }
        2 { Set-MkvTrackLanguage }
        3 { Set-MkvTrackName }
        4 { Remove-MkvTitleMetaData }
        5 { Exit }
    }
}