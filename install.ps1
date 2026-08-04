# Installs:
#   - Copies profile.ps1 from this directory to $PROFILE
#   - Optionally installs Winget packages (Windows only)

# -----------------------------------------
# Winget dependencies
# Add/remove packages here.
# Name = Display name (decorative)
# Id   = Winget package ID
# -----------------------------------------

$WingetPackages = @(
    @{
        Name = "Fastfetch"
        Id   = "Fastfetch-cli.Fastfetch"
    }
    # @{
    #     Name = "Git"
    #     Id   = "Git.Git"
    # }
    # @{
    #     Name = "7-Zip"
    #     Id   = "7zip.7zip"
    # }
    # @{
    #     Name = "Neovim"
    #     Id   = "Neovim.Neovim"
    # }
)

# -----------------------------------------
# Winget installs (Windows only)
# -----------------------------------------

if ($IsWindows -or $env:OS -eq "Windows_NT") {

    $winget = Get-Command winget -ErrorAction SilentlyContinue

    if (-not $winget) {
        Write-Warning "winget is not installed. Skipping package installation."
    }
    else {

        $InstallRemaining = $false
        $SkipRemaining    = $false

        foreach ($pkg in $WingetPackages) {

            $Install = $InstallRemaining

            if (-not $InstallRemaining) {
                Write-Host ""
                Write-Host "Install $($pkg.Name)?"
                Write-Host '[Y] Yes   [A] All remaining   [N] No (default)   [L] No to all remaining'

                $choice = (Read-Host "Choice").Trim().ToUpper()

                switch ($choice) {
                    "Y" {
                        $Install = $true
                    }
                    "A" {
                        $InstallRemaining = $true
                        $Install = $true
                    }
                    "L" {
                        $SkipRemaining = $true
                        $Install = $false
                    }
                    default {
                        Write-Host "Skipped."
                        $Install = $false
                    }
                }
            }

            if ($SkipRemaining) {
                break
            }

            if (-not $Install) {
                continue
            }

            Write-Host ""
            Write-Host "Installing $($pkg.Name)..."

            winget install `
                --id $pkg.Id `
                --exact `
                --accept-package-agreements `
                --accept-source-agreements
        }

        Write-Host ""
    }
}
else {
    Write-Host "Linux detected."
    Write-Host "Winget package installation skipped."
}

# -----------------------------------------
# Profile install
# -----------------------------------------

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceFile  = Join-Path $ScriptDir "powershell/profile.ps1"

if (-not (Test-Path $SourceFile)) {
    Write-Error "profile.ps1 not found:"
    exit 1
}

$TargetFile = Join-Path $HOME ".config/powershell/MyProfile.ps1"

# Make dir exist
$profileDir = Split-Path $TargetFile -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
}

# Copy profile
Copy-Item $SourceFile $TargetFile -Force

# Ensure the user's profile exists
$ProfileDir = Split-Path $PROFILE -Parent
New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

# Append loader if it doesn't already exist
$Loader = ". `"$TargetFile`""

if (-not (Select-String -Path $PROFILE -SimpleMatch $Loader -Quiet)) {
    Add-Content -Path $PROFILE -Value @"

# Load my profile
$Loader

"@
}

Write-Host "Installed profile:"
Write-Host "  $TargetFile"
Write-Host ""

Write-Host "Done."