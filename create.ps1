# ==========================
# create.ps1
# ==========================

$indexFile = "index.json"

if (!(Test-Path $indexFile)) {
    Write-Host "index.json not found!" -ForegroundColor Red
    exit
}

$data = Get-Content $indexFile -Raw | ConvertFrom-Json

$data.PSObject.Properties | ForEach-Object {

    $folder = $_.Name
    $chapters = $_.Value

    # Folder create
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder | Out-Null
        Write-Host "Created Folder : $folder"
    }

    foreach ($chapter in $chapters) {

        $file = Join-Path $folder ($chapter + ".json")

        if (!(Test-Path $file)) {

            $title = ($chapter -replace "^\d+_", "") -replace "_"," "

            $content = @{
                title = $title
                duration_minutes = 30
                questions = @()
            }

            $content |
            ConvertTo-Json -Depth 10 |
            Set-Content $file -Encoding UTF8

            Write-Host "Created : $file"
        }
        else {

            Write-Host "Skip : $file"

        }

    }

}

Write-Host ""
Write-Host "===================================="
Write-Host "All JSON files created successfully."
Write-Host "===================================="