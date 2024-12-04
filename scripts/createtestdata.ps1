param(
    [Parameter(Mandatory=$false)]
    [string]$TargetPath = ".\TestData",
    [Parameter(Mandatory=$false)]
    [int]$TotalSizeMB = 10
)

# Display warning and get confirmation
Write-Host "`nWARNING: This script will generate approximately $TotalSizeMB MB of random test files in: $TargetPath" -ForegroundColor Yellow
Write-Host "Type 'YES' to proceed: " -ForegroundColor Yellow -NoNewline
$confirmation = Read-Host

if ($confirmation -ne "YES") {
    Write-Host "`nOperation cancelled by user" -ForegroundColor Red
    exit
}

# Create target directory if it doesn't exist
if (-not (Test-Path $TargetPath)) {
    New-Item -ItemType Directory -Path $TargetPath | Out-Null
    Write-Host "`nCreated directory: $TargetPath"
}

# Define possible file extensions and their content types
$fileTypes = @(
    @{Extension = ".txt"; ContentType = "text"},
    @{Extension = ".log"; ContentType = "text"},
    @{Extension = ".dat"; ContentType = "binary"},
    @{Extension = ".bin"; ContentType = "binary"},
    @{Extension = ".json"; ContentType = "json"},
    @{Extension = ".xml"; ContentType = "xml"},
    @{Extension = ".csv"; ContentType = "csv"},
    @{Extension = ".md"; ContentType = "markdown"}
)

# Convert MB to bytes for calculations
$totalBytes = $TotalSizeMB * 1MB
$bytesCreated = 0
$fileCount = 0

# Function to generate random text content
function Get-RandomText {
    param([int]$length)
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 .,!?-_'
    return -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}

# Function to generate random JSON content
function Get-RandomJson {
    param([int]$complexity)
    $data = @{
        id = [guid]::NewGuid().ToString()
        timestamp = Get-Date
        value = Get-Random -Minimum 1 -Maximum 1000
        items = @()
    }
    1..$complexity | ForEach-Object {
        $data.items += @{
            name = "Item$_"
            value = Get-Random -Minimum 1 -Maximum 100
            active = (Get-Random -Minimum 0 -Maximum 2) -eq 1
        }
    }
    return $data | ConvertTo-Json
}

# Function to generate random XML content
function Get-RandomXml {
    param([int]$complexity)
    $xmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<root>
    <metadata>
        <id>$(([guid]::NewGuid().ToString()))</id>
        <timestamp>$((Get-Date).ToString('o'))</timestamp>
    </metadata>
    <data>
"@
    1..$complexity | ForEach-Object {
        $xmlContent += @"
        <item>
            <name>Item$_</name>
            <value>$(Get-Random -Minimum 1 -Maximum 100)</value>
            <active>$((Get-Random -Minimum 0 -Maximum 2) -eq 1)</active>
        </item>
"@
    }
    $xmlContent += @"
    </data>
</root>
"@
    return $xmlContent
}

# Function to generate random CSV content
function Get-RandomCsv {
    param([int]$rows)
    $csv = "ID,Name,Value,Date`n"
    1..$rows | ForEach-Object {
        $csv += "$(([guid]::NewGuid().ToString())),Item$_,$(Get-Random -Minimum 1 -Maximum 1000),$((Get-Date).AddDays(-$_).ToString('yyyy-MM-dd'))`n"
    }
    return $csv
}

Write-Host "`nGenerating files..." -ForegroundColor Cyan

# Generate files until we reach the target size
while ($bytesCreated -lt $totalBytes) {
    $fileType = $fileTypes | Get-Random
    $fileSize = Get-Random -Minimum 1KB -Maximum ([Math]::Min(1MB, $totalBytes - $bytesCreated))
    $fileName = "file_$(Get-Random)$($fileType.Extension)"
    $filePath = Join-Path $TargetPath $fileName
    
    switch ($fileType.ContentType) {
        "text" {
            Get-RandomText -length $fileSize | Out-File -FilePath $filePath -NoNewline
        }
        "binary" {
            $buffer = [byte[]]::new($fileSize)
            (New-Object Random).NextBytes($buffer)
            [IO.File]::WriteAllBytes($filePath, $buffer)
        }
        "json" {
            $complexity = [Math]::Max(1, [Math]::Min(100, $fileSize / 100))
            Get-RandomJson -complexity $complexity | Out-File -FilePath $filePath
        }
        "xml" {
            $complexity = [Math]::Max(1, [Math]::Min(100, $fileSize / 100))
            Get-RandomXml -complexity $complexity | Out-File -FilePath $filePath
        }
        "csv" {
            $rows = [Math]::Max(1, [Math]::Min(1000, $fileSize / 50))
            Get-RandomCsv -rows $rows | Out-File -FilePath $filePath -NoNewline
        }
        "markdown" {
            Get-RandomText -length $fileSize | Out-File -FilePath $filePath -NoNewline
        }
    }
    
    $actualSize = (Get-Item $filePath).Length
    $bytesCreated += $actualSize
    $fileCount++
    
    Write-Host "Created $fileName ($([math]::Round($actualSize/1KB, 2)) KB)" -ForegroundColor Green
}

Write-Host "`nComplete!" -ForegroundColor Cyan
Write-Host "Generated $fileCount files totaling $([math]::Round($bytesCreated/1MB, 2)) MB in $TargetPath" -ForegroundColor Cyan