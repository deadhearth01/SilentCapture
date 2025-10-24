# Screen Capture Script for Entire Screen at Hardcoded Max Resolution, 1 FPS, Dynamic User Downloads Path, Logging, and Auto-Exit
# Saves screenshots to <User>\Downloads\SilentCapure
# Author: Adapted from community scripts

param(
    [int]$IntervalMs = 500  # Time between screenshots (ms) - 1000ms = 1 FPS
)

# Ensure STA mode for graphics compatibility
if ([Threading.Thread]::CurrentThread.GetApartmentState() -ne 'STA') {
    Write-Warning "Script must run in STA mode. Relaunching..."
    $scriptPath = $MyInvocation.MyCommand.Path
    Start-Process powershell -ArgumentList "-Sta -File `"$scriptPath`"" -Wait
    exit
}

# Load required assemblies
Add-Type -AssemblyName System.Drawing, System.Windows.Forms

# Dynamic path based on current user's Downloads folder
$OutputFolder = Join-Path $env:USERPROFILE "Music\SilentCapure"

# Log function for consistent output
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$Timestamp] $Level : $Message" -ForegroundColor $(switch ($Level) {
        "INFO" { "Green" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        default { "White" }
    })
}

# Create output folder
Write-Log "Creating output folder..."
try {
    if (!(Test-Path $OutputFolder)) { New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null }
    Write-Log "Output folder created: $OutputFolder"
}
catch {
    Write-Log "Failed to create output folder: $_" -Level "ERROR"
    Write-Log "Script cannot continue. Closing terminal in 2 seconds..." -Level "ERROR"
    Start-Sleep -Seconds 2
    Exit
}

# Hardcode maximum resolution
$Width = 1920
$Height = 1080
$X = 0
$Y = 0
$screen = [System.Drawing.Rectangle]::new($X, $Y, $Width, $Height)
Write-Log "Capturing screen at hardcoded resolution: Width=$Width, Height=$Height"

# Global counter for sequential filenames
$global:Seq = 0

# Function to capture screen
function Take-Screenshot {
    param([string]$Path)
    
    Write-Log "Capturing screenshot #$($global:Seq + 1)..."
    try {
        $bitmap = New-Object System.Drawing.Bitmap $Width, $Height
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
            try {
                $graphics.CopyFromScreen($X, $Y, 0, 0, $screen.Size)
                $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
                Write-Log "Saved screenshot: $Path"
            }
            catch {
                Write-Log "Error during screen capture or save: $_" -Level "ERROR"
            }
        }
        finally {
            if ($graphics) { $graphics.Dispose() }
        }
    }
    catch {
        Write-Log "Error creating bitmap: $_" -Level "ERROR"
    }
    finally {
        if ($bitmap) { $bitmap.Dispose() }
    }
}

# Timer setup for periodic captures
Write-Log "Setting up timer for $IntervalMs ms interval..."
try {
    $RecTimer = New-Object System.Timers.Timer
    $TakeScreenshotScriptBlock = {
        try {
            $global:Seq++
            $FileName = "Shot$($global:Seq.ToString('0000')).png"
            $FullPath = Join-Path $OutputFolder $FileName
            Take-Screenshot -Path $FullPath
        }
        catch {
            Write-Log "Error during capture: $_" -Level "ERROR"
        }
    }

    $RecTimer.Interval = $IntervalMs
    Register-ObjectEvent -InputObject $RecTimer -EventName Elapsed -SourceIdentifier RecTimer -Action $TakeScreenshotScriptBlock | Out-Null
}
catch {
    Write-Log "Error setting up timer: $_" -Level "ERROR"
    Write-Log "Script cannot continue. Closing terminal in 2 seconds..." -Level "ERROR"
    Start-Sleep -Seconds 2
    Exit
}

# Start capturing
Write-Log "Starting screen capture (Interval: ${IntervalMs}ms, 1 FPS)"
Write-Log "Screenshots will be saved to: $OutputFolder"
Write-Log "Press Ctrl+C to stop capturing..."
try {
    $RecTimer.Start() | Out-Null
}
catch {
    Write-Log "Error starting timer: $_" -Level "ERROR"
    Write-Log "Script cannot continue. Closing terminal in 2 seconds..." -Level "ERROR"
    Start-Sleep -Seconds 2
    Exit
}

try {
    # Keep script running until interrupted
    while ($true) { Start-Sleep -Seconds 1 }
}
finally {
    # Stop timer and clean up
    try {
        $RecTimer.Stop() | Out-Null
        Unregister-Event -SourceIdentifier RecTimer -ErrorAction SilentlyContinue
        Write-Log "Screen capture stopped."
    }
    catch {
        Write-Log "Error stopping timer: $_" -Level "ERROR"
    }
    Write-Log "Script execution complete. Closing terminal in 2 seconds..."
    Start-Sleep -Seconds 2
    Exit
}