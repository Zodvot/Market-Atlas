# Run from any directory. PostgreSQL requests your password privately.
$ErrorActionPreference = 'Stop'
$psqlPath = 'C:\Program Files\PostgreSQL\18\bin\psql.exe'
if (-not (Test-Path -LiteralPath $psqlPath)) {
    throw 'PostgreSQL 18 command-line tools were not found at the expected location.'
}
& $psqlPath -X -h localhost -U postgres -d postgres -W -v ON_ERROR_STOP=1 -f "$PSScriptRoot\create-database.sql"
if ($LASTEXITCODE -ne 0) { throw 'Database creation failed.' }
& $psqlPath -X -h localhost -U postgres -d market_atlas -W -v ON_ERROR_STOP=1 -f "$PSScriptRoot\setup.sql"
if ($LASTEXITCODE -ne 0) { throw 'Table setup failed.' }
Write-Host 'Market Atlas database setup completed.'
