# Pobierz pliki z bieżącego katalogu, które kończą się na _(Vocals).wav.
$vocalFiles = Get-ChildItem -File -Filter "*_(Vocals).wav"

# Definicja wyrażenia regularnego.
$regex = '^(?<number>\d+)_s(?<season>\d{2})e(?<episode>\d{2})(?:_\((?<version>[^)]+)\))?\.wav$'

if ($vocalFiles.Count -eq 0) {
    Write-Output "Nie znaleziono plików pasujących do filtru '*_(Vocals).wav'"
    exit
}

foreach ($file in $vocalFiles) {
    if ($file.Name -match $regex) {
        $VocalNumber = $matches['number']
        $Season = $matches['season']
        $Episode = $matches['episode']
        $Version = $matches['version']

        Write-Output "Plik '$($file.Name)' pasuje do wzorca."
        Write-Output "  Numer:   $VocalNumber"
        Write-Output "  Sezon:   $Season"
        Write-Output "  Odcinek: $Episode"
        Write-Output "  Wersja:  $Version"
        Write-Output "-------------------------------"
        
        # Budowanie nazw plików wejściowych i wyjściowego
        $vocalInput = "$VocalNumber`_s$Season" + "e$Episode`_(Vocals).wav"
        $instInput  = "$VocalNumber`_s$Season" + "e$Episode`_(Instrumental).wav"
        $outputFile = "s${Season}e${Episode}.opus"
        
        # Pomijanie, jeśli plik wyjściowy już istnieje
        if (Test-Path $outputFile) {
            Write-Output "Plik $outputFile już istnieje. Pomijam."
            continue
        }
        
        # Sprawdzanie czy pliki wejściowe istnieją
        if (-Not (Test-Path $vocalInput)) {
            Write-Error "Plik $vocalInput nie istnieje!"
            continue
        }
        
        if (-Not (Test-Path $instInput)) {
            Write-Error "Plik $instInput nie istnieje!"
            continue
        }
        
        # Przygotowanie polecenia ffmpeg
        $ffmpegCommand = @(
            "-i", $vocalInput,
            "-i", $instInput,
            "-filter_complex", '[0:a]volume=1.0[a];[1:a]volume=1.7[b];[a][b]amix=inputs=2[mixed];[mixed]volume=2.5',
            "-c:a", "libopus",
            "-b:a", "128k",
            $outputFile
        )
        
        # Wykonanie polecenia ffmpeg
        Write-Output "Rozpoczynam przetwarzanie..."
        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = "ffmpeg"
        $processInfo.Arguments = $ffmpegCommand -join " "
        $processInfo.RedirectStandardOutput = $false
        $processInfo.RedirectStandardError  = $false
        $processInfo.UseShellExecute = $true
        
        $process = [System.Diagnostics.Process]::Start($processInfo)
        $process.WaitForExit()
        
        if ($process.ExitCode -eq 0) {
            Write-Output "Przetwarzanie zakończone. Utworzono: $outputFile"
        } else {
            Write-Error "ffmpeg zakończył się z kodem $($process.ExitCode). Sprawdź logi."
        }
    } else {
        Write-Output "Plik '$($file.Name)' NIE pasuje do wzorca."
    }
}