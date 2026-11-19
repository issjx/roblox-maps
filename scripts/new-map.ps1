# Creates maps/<name>/ from maps/_template on a new branch map/<name>.
#   powershell -ExecutionPolicy Bypass -File scripts\new-map.ps1 lava-run "Lava Run"
param(
    [Parameter(Mandatory = $true)][string]$Name,
    [string]$Title = "",
    [string]$Owner = ""
)
$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

if ($Name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { throw "Use kebab-case, e.g. lava-run" }
if (Test-Path "maps\$Name") { throw "maps\$Name already exists" }
if ($Title -eq "") { $Title = (Get-Culture).TextInfo.ToTitleCase($Name.Replace("-", " ")) }
if ($Owner -eq "") { $Owner = (git config user.name) }

git switch main
git pull
git switch -c "map/$Name"

Copy-Item -Recurse "maps\_template" "maps\$Name"
$utf8 = New-Object System.Text.UTF8Encoding($false)

$project = (Get-Content "maps\$Name\default.project.json" -Raw) -replace '"name": "_template"', "`"name`": `"$Name`""
[IO.File]::WriteAllText("$PWD\maps\$Name\default.project.json", $project, $utf8)

$meta = [ordered]@{
    name        = $Title
    description = "TODO: one line about the map"
    owner       = $Owner
    status      = "wip"
    maxPlayers  = 20
    universeId  = $null
    placeId     = $null
}
[IO.File]::WriteAllText("$PWD\maps\$Name\map.json", (($meta | ConvertTo-Json) -replace "`r`n", "`n") + "`n", $utf8)

$readme = (Get-Content "maps\$Name\README.md" -Raw) -replace '# Template', "# $Title" -replace "(?s)Copied by.*?directly\.\r?\n\r?\n", ""
[IO.File]::WriteAllText("$PWD\maps\$Name\README.md", ($readme -replace "`r`n", "`n"), $utf8)

Write-Host "`nCreated maps\$Name on branch map/$Name." -ForegroundColor Green
Write-Host "Next:  rojo build maps\$Name -o build\$Name.rbxl   then open it in Studio (docs\MAP-WORKFLOW.md)"
