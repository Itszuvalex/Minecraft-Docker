param (
    [String] $server,
    [Switch] $extract,
    [Switch] $setup,
    [Switch] $build,
    [Switch] $remove
)

pushd $PSScriptRoot

if($extract) {
    Write-Host "Extracting..."
    mkdir mcserver
    pushd mcserver
    7z.exe x """$server""" *
    popd
}

if($setup) {
    Write-Host "Setting up server..."
    pushd mcserver
    cmd.exe /c "ServerStart.bat"
    sed -i -e 's/false/true/g' eula.txt
    cmd.exe /c "ServerStart.bat"
    popd
}

if($build) {
    Write-Host "Building Dockerfile..."
    docker build --build-arg serverzip=%~n1 .
}

if($remove) {
    Write-Host "Cleaning up..."
    rmdir /s /q mcserver
}

popd
