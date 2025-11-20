# --- Configuration ---

# Path to PyMOL executable
$PYMOL_PATH = "C:\pymol\pymol.exe"

# Output directory
$OUTPUT_DIR = "C:\RENDER"

$CONFIG_FILE = "render_config.txt"
$DEFAULT_WIDTH = 4000
$DEFAULT_HEIGHT = 4000
$OUTPUT_FORMAT = "png"

# PyMOL rendering settings
$PYMOL_SETTINGS = @"
set ray_shadow, 1
set ray_trace_mode, 1
set antialias, 4
"@

# Create output directory if missing
if (-not (Test-Path $OUTPUT_DIR)) {
    Write-Host "Creating output directory: $OUTPUT_DIR"
    New-Item -ItemType Directory -Force -Path $OUTPUT_DIR | Out-Null
}

# Function to get resolution from config file
function Get-Resolution {
    param ([string]$Filename)

    $width = $DEFAULT_WIDTH
    $height = $DEFAULT_HEIGHT

    if (Test-Path $CONFIG_FILE) {
        $lines = Get-Content $CONFIG_FILE
        foreach ($line in $lines) {
            if ($line -match "^\s*$Filename\s+(\d+)\s+(\d+)") {
                $width = [int]$matches[1]
                $height = [int]$matches[2]
            }
        }
    }
    return @{
        width = $width
        height = $height
    }
}

$found = $false

foreach ($file in Get-ChildItem *.pse) {
    if ($file) {
        $found = $true

        $basename = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $outputFile = "$basename.$OUTPUT_FORMAT"
        $outputPath = Join-Path $OUTPUT_DIR $outputFile
        $outputBase = [System.IO.Path]::Combine($OUTPUT_DIR, $basename)

        $res = Get-Resolution $basename
        $width = $res.width
        $height = $res.height

        Write-Host "============================================================"
        Write-Host "Rendering $file -> $outputPath ($width x $height)"
        Write-Host "============================================================"

        # Build PyMOL command
        $cmd = @"
$PYMOL_SETTINGS
ray $width,$height
png $outputBase
quit
"@

        # Run PyMOL
        & $PYMOL_PATH -cq $file.FullName -d $cmd
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: PyMOL rendering failed for $file"
        }
    }
}

if (-not $found) {
    Write-Host "No .pse files found in the current directory."
    exit 1
}

Write-Host "============================================================"
Write-Host "RENDERING FINISHED SUCCESSFULLY"
Write-Host "============================================================"
