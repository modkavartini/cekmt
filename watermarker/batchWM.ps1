
function initial($type) {
    mkdir backup/$type
    mkdir $type
}

function doLandscape {
    initial -type landscape
    $l = 1
    get-ChildItem -filter *.jpg | forEach-Object {
        copy-Item $_ backup/landscape
        magick $_ wmL.png -gravity south -geometry +0+30 -composite "$_"
        move-Item $_ landscape
        write-Host "landscape: done #$l"
        $l++
    }
}

function doPortrait {
    initial -type portrait
    $p = 1
    get-ChildItem -filter *.jpg | forEach-Object {
        copy-Item $_ backup/portrait
        magick $_ wmP.png -gravity west -geometry +0+30 -composite "$_"
        move-Item $_ portrait
        write-Host "portrait: done #$p"
        $p++
    }
}