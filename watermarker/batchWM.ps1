
$path = $pSScriptRoot

function doWMAuto {
    param(
        [switch]
        $phone,
        [switch]
        $backup,
        [string]
        $folder = (get-Date -format "MM/dd/yyyy")
    )
    $p = 0
    $i = 0
    $orientation = 'unknown', 'landscape', 'flipHorizontal', 'rotate180', 'flipVertical', 'transpose', 'rotate270', 'transverse', 'portrait'
    new-Item -itemType directory "$path\$folder" -eA 0
    if ($backup) { new-Item -itemType directory "$path\backup-$folder" -eA 0 }
    get-ChildItem $path -filter *.jpg | forEach-Object { $p++ }
    $est = (($p/10)*16)
    clear-Host
    write-Host "found $p photos!" -foregroundColor blue
    write-Host "estimated time: $(hhmm($est))" -foregroundColor red
    write-Host "starting..." -foregroundColor green
    $start = currentTime
    get-ChildItem $path -filter *.jpg | forEach-Object {
        $name = split-Path $_ -leaf
        $img = [system.Drawing.Image]::fromFile($_.fullName)
        $value = $img.getPropertyItem(274).Value[0]
        $current = $orientation[$value]
        $img.Dispose()
        if (($backup) -and (($value -eq 1) -or ($value -eq 8))) {
            copy-Item $_ "$path\backup-$folder"
        }
        if ($current -eq "landscape") {
            if ($phone) { magick $_ "$path\assets\wmPhoneL.png" -gravity south -geometry +0+300 -composite "$_" }
            else { magick $_ "$path\assets\wmL.png" -gravity south -geometry +0+30 -composite "$_" }
            write-Host "landscape: #$i/$p - $name" -foregroundColor yellow
        }
        elseif ($current -eq "portrait") {
            #add phone here too
            magick $_ "$path\assets\wmP.png" -gravity west -geometry +0+30 -composite "$_"
            write-Host "portrait:  #$i/$p - $name" -foregroundColor yellow
        }
        else {
            write-Host "$($name): neither portrait nor landscape. has " -noNewLine -foregroundColor red
            write-Host "$current " -noNewLine -foregroundColor blue
            write-Host "skipping..." -foregroundColor red
            $i--
        }
        $i++
    }
    move-Item "$path\*.jpg" "$path\$folder"
    $end = currentTime
    write-Host "done! all $i pictures took $(hhmm($end-$start))!" -foregroundColor green
    beepHappy
}

function hhmm($sec) {
    $h = [math]::floor(($sec / 3600))
    $m = [math]::floor(($sec % 3600) / 60)
    $s = [math]::floor(($sec % 3600) % 60)
    $h = $h -replace "^\d$","0$h"
    $m = $m -replace "^\d$","0$m"
    $s = $s -replace "^\d$","0$s"
    return "$($h):$($m):$($s)"
}

function currentTime {
    return [math]::floor(((get-Date) - [dateTime]::today).totalSeconds)
}

function beepHappy {
    nircmd.exe beep 784 100
    nircmd.exe beep 880 100
    nircmd.exe beep 988 100
    nircmd.exe beep 1047 100
    nircmd.exe beep 1175 100
    nircmd.exe beep 1319 100
    nircmd.exe beep 1397 100
    nircmd.exe beep 1568 100
}