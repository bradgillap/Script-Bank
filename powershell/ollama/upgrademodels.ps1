ollama list | Select-Object -Skip 1 | ForEach-Object {
    $modelName = ($_ -split '\s+')[0]
    if ($modelName) {
        Write-Host "Updating model: $modelName" -ForegroundColor Yellow
        ollama pull $modelName
    }
}
Write-Host "All models updated." -ForegroundColor Green
