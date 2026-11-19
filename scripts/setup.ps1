# One-time setup for a fresh clone on Windows.  Run from the repo root:
#   powershell -ExecutionPolicy Bypass -File scripts\setup.ps1
#
# Installs: Rokit (toolchain manager) -> Rojo, StyLua, Selene, Lune at the versions pinned in rokit.toml,
# the Rojo plugin for Roblox Studio, the VS Code extensions, and this repo's git hooks.

$ErrorActionPreference = "Stop"
Set-Location (Split-Path $PSScriptRoot -Parent)

function Step($text) { Write-Host "`n== $text" -ForegroundColor Cyan }

Step "Rokit"
if (-not (Get-Command rokit -ErrorAction SilentlyContinue) -and -not (Test-Path "$env:USERPROFILE\.rokit\bin\rokit.exe")) {
    winget install --id Rojo.Rokit -e --accept-package-agreements --accept-source-agreements
}
$env:Path = "$env:USERPROFILE\.rokit\bin;$env:Path"
rokit self-install
$env:Path = "$env:USERPROFILE\.rokit\bin;$env:Path"

Step "Tools from rokit.toml (rojo, stylua, selene, lune)"
rokit install --no-trust-check

Step "Rojo plugin for Roblox Studio"
rojo plugin install

Step "Git hooks"
git config core.hooksPath .githooks
git config pull.rebase false

Step "VS Code extensions"
if (Get-Command code -ErrorAction SilentlyContinue) {
    foreach ($ext in @("evaera.vscode-rojo", "JohnnyMorganz.luau-lsp", "JohnnyMorganz.stylua", "Kampfkarren.selene-vscode", "EditorConfig.EditorConfig")) {
        code --install-extension $ext --force | Out-Null
        Write-Host "  $ext"
    }
} else {
    Write-Host "  VS Code not found - skipped (optional)."
}

Step "Done. Restart your terminal / GitHub Desktop so the new PATH is picked up."
