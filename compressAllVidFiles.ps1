$inputFolder = Get-Location
$outputFolder = "$inputFolder\compressed"

# Upewnij się, że folder wyjściowy istnieje
if (!(Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

# Przejście przez wszystkie pliki MP4 w katalogu wejściowym
Get-ChildItem -Path $inputFolder -Filter "*.mp4" | ForEach-Object {
    $inputFile = $_.FullName
    $outputFile = "$outputFolder\$($_.BaseName)compressed.mkv"
    
    # Sprawdź, czy plik wyjściowy już istnieje, jeśli tak - pomiń
    if (!(Test-Path $outputFile)) {
        ffmpeg -i "$inputFile" -n -c:v hevc_nvenc -preset p7 -tune hq -multipass fullres -rc constqp -qp 24 -profile:v main -pix_fmt yuv420p -b_ref_mode each -spatial-aq 1 -temporal-aq 1 -aq-strength 15 -bf 5 -b_strategy 1 -c:a copy "$outputFile"
    } else {
        Write-Host "Plik już istnieje, pomijam: $outputFile"
    }
}
