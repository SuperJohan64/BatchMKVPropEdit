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

foreach ($file in (Get-ChildItem -LiteralPath $sourceDir -Include *.mkv -Recurse).FullName) {
    Write-Host `n$file
    & $mkvpropedit $file `
        -d title `
}