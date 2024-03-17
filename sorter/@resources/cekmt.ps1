
$img = get-Clipboard
$root = split-Path $img
$personal = $root + "\personal"
new-Item -itemType directory $personal -eA 0
move-Item $img $personal
nircmd.exe beep 700 150
