# Windows wrapper for scripts/check.sh (runs it with Git's bash, not WSL's).
#   powershell -ExecutionPolicy Bypass -File scripts\check.ps1
$gitBash = Join-Path (Split-Path (Split-Path (Get-Command git).Source)) "bin\bash.exe"
$env:Path = "$env:USERPROFILE\.rokit\bin;$env:Path"
& $gitBash (Join-Path $PSScriptRoot "check.sh")
exit $LASTEXITCODE
