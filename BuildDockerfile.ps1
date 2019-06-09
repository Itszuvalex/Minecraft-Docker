param (
    [String] $server,
	[String] $mcVer,
	[String] $forgeVer,
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
    Write-Host "Installing forge..."
    pushd mcserver
	wget "https://files.minecraftforge.net/maven/net/minecraftforge/forge/$($mcVer)-$($forgeVer)/forge-$($mcVer)-$($forgeVer)-installer.jar" -OutFile installer.jar
    java -jar installer.jar --installServer
	$JarPath = Resolve-Path forge-*-*-universal.jar
	Rename-Item -Path $JarPath -NewName "forge-universal.jar"
	Write-Host "Cleaning forge installer..."
	Remove-Item installer.jar
	Remove-Item installer.jar.txt
	Write-Host "Starting server to generate eula..."
	java -jar "forge-universal.jar" -Xmx2G nogui
    (Get-Content eula.txt) -replace 'false','true' | Set-Content eula.txt
    popd
}

if($build) {
    Write-Host "Pulling runner..."
	git clone https://github.com/Itszuvalex/Minecraft-Runner
	Write-Host "Building runner..."
	[Environment]::SetEnvironmentVariable("GOPATH", "$PSScriptRoot\Minecraft-Runner")
	[Environment]::SetEnvironmentVariable("GOOS", "linux")
	[Environment]::SetEnvironmentVariable("GOARCH", "amd64")
	pushd Minecraft-Runner
	pushd src
	pushd mcrunner
	dep ensure
	popd
	popd
	popd
	go build main
	Write-Host "Building Dockerfile..."
    docker build --build-arg serverzip=%~n1 .
	Write-Host "Cleaning build files..."
	Remove-Item -Force -Recurse -Path "Minecraft-Runner"
	Remove-Item main
}

if($remove) {
    Write-Host "Cleaning up..."
    rmdir /s /q mcserver
}

popd
