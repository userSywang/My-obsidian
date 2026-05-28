param(
    [string]$date = "",
    [string]$content = ""
)

$diaryPath = "股票学习\随记\股票日记.md"

if (-not (Test-Path $diaryPath)) {
    Write-Host "❌ 找不到日记文件: $diaryPath" -ForegroundColor Red
    exit 1
}

# 获取日期
if ([string]::IsNullOrEmpty($date)) {
    $inputDate = Read-Host "📅 输入日期 (格式: YYYY-MM-DD，回车默认今天)"
    if ([string]::IsNullOrEmpty($inputDate)) {
        $date = Get-Date -Format "yyyy-MM-dd"
    } else {
        $date = $inputDate
    }
}

# 获取内容
if ([string]::IsNullOrEmpty($content)) {
    Write-Host "📝 输入今日日记内容 (输入完后按 Enter，空行则回车结束):" -ForegroundColor Cyan
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

# 构建日记条目
$entry = @"

### $date

$content
"@

# 追加到文件末尾
Add-Content -Path $diaryPath -Value $entry

Write-Host "`n✅ 日记已添加到 $date" -ForegroundColor Green
Write-Host "📄 $diaryPath" -ForegroundColor Gray
