# ============================================================
#  FORT LOCAÇÕES - Atualizar Galeria de Fotos e Vídeos
#  Execute este script sempre que adicionar novos arquivos
#  na pasta "galeria/"
# ============================================================

$ScriptDir    = Split-Path -Parent $MyInvocation.MyCommand.Path
$GalleryPath  = Join-Path $ScriptDir "galeria"
$ManifestPath = Join-Path $GalleryPath "manifest.json"

$imageExts = @("*.jpg", "*.jpeg", "*.png", "*.webp")
$videoExts = @("*.mp4", "*.webm", "*.mov")

$files = @()

foreach ($ext in $imageExts) {
    Get-ChildItem -Path $GalleryPath -Filter $ext | ForEach-Object {
        $files += [ordered]@{ name = $_.Name; type = "image" }
    }
}

foreach ($ext in $videoExts) {
    Get-ChildItem -Path $GalleryPath -Filter $ext | ForEach-Object {
        $files += [ordered]@{ name = $_.Name; type = "video" }
    }
}

$manifest = [ordered]@{ files = $files }
$json = $manifest | ConvertTo-Json -Depth 4
Set-Content -Path $ManifestPath -Value $json -Encoding UTF8

$totalFotos   = ($files | Where-Object { $_.type -eq "image" }).Count
$totalVideos  = ($files | Where-Object { $_.type -eq "video" }).Count

Write-Host ""
Write-Host "✅ Galeria atualizada com sucesso!" -ForegroundColor Green
Write-Host "   Fotos  : $totalFotos" -ForegroundColor Cyan
Write-Host "   Vídeos : $totalVideos" -ForegroundColor Cyan
Write-Host "   Total  : $($files.Count) arquivo(s)" -ForegroundColor Cyan

if ($files.Count -gt 0) {
    Write-Host ""
    Write-Host "   Arquivos incluídos:" -ForegroundColor Yellow
    $files | ForEach-Object {
        $icon = if ($_.type -eq "video") { "🎬" } else { "🖼️ " }
        Write-Host "     $icon $($_.name)" -ForegroundColor White
    }
} else {
    Write-Host ""
    Write-Host "   ⚠️  Nenhum arquivo encontrado na pasta 'galeria/'." -ForegroundColor Yellow
    Write-Host "   Adicione fotos (.jpg, .png, .webp) ou vídeos (.mp4, .webm, .mov)." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "   Abra o site no navegador para ver as mudanças." -ForegroundColor Cyan
Write-Host ""
Read-Host "Pressione Enter para fechar"
