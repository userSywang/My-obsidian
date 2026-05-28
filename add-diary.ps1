param(
    [string]$date = "",
    [string]$content = ""
)

$diaryPath = "随记\股票日记.md"
$vaultRoot = Split-Path -Parent $PSScriptRoot
if (Test-Path (Join-Path $vaultRoot $diaryPath)) {
    $diaryPath = Join-Path $vaultRoot $diaryPath
} elseif (Test-Path $diaryPath) {
    # 已存在
} else {
    Write-Host "❌ 找不到日记文件" -ForegroundColor Red
    exit 1
}

# 获取日期
if ([string]::IsNullOrEmpty($date)) {
    $inputDate = Read-Host "📅 输入日期 (YYYY-MM-DD，回车默认今天)"
    if ([string]::IsNullOrEmpty($inputDate)) {
        $date = Get-Date -Format "yyyy-MM-dd"
    } else {
        $date = $inputDate
    }
}

# 获取内容
if ([string]::IsNullOrEmpty($content)) {
    Write-Host "📝 输入日记内容 (输入完后空行回车结束):" -ForegroundColor Cyan
    $lines = @()
    while ($true) {
        $line = Read-Host
        if ([string]::IsNullOrEmpty($line)) { break }
        $lines += $line
    }
    if ($lines.Count -eq 0) {
        Write-Host "❌ 内容不能为空" -ForegroundColor Red
        exit 1
    }
    $content = $lines -join "`n"
}

# 构建新日记条目
$newEntry = "`n### $date`n`n$content`n"

# 读取当前内容
$currentContent = Get-Content $diaryPath -Raw

# 在第一个 "### 2026/" 前面插入（保持最新在最上）
$insertMarker = "`n### 2026/"
$insertPos = $currentContent.IndexOf($insertMarker)

if ($insertPos -ge 0) {
    $newContent = $currentContent.Substring(0, $insertPos) + $newEntry + $currentContent.Substring($insertPos)
} else {
    # 容错：追加到末尾
    $newContent = $currentContent + $newEntry
}

# 写回文件
Set-Content $diaryPath -Value $newContent -Encoding UTF8

Write-Host "`n✅ 日记已追加 ($date)" -ForegroundColor Green
Write-Host "📄 $diaryPath" -ForegroundColor Gray
