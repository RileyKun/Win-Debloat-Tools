Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"show-dialog-window.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"title-templates.psm1"

function Open-PowerShellFilesCollection {
    param (
        [String] $RelativeLocation,
        [Array]  $Scripts,
        [String] $DoneTitle,
        [String] $DoneMessage,
        [Parameter(Mandatory = $false)]
        [Bool]   $OpenFromGUI = $true,
        [Parameter(Mandatory = $false)]
        [Switch] $NoDialog
    )

    Push-Location -Path "$PSScriptRoot\..\..\$RelativeLocation"
    Get-ChildItem -Recurse *.ps*1 | Unblock-File

    ForEach ($FileName in $Scripts) {
        Write-TitleCounter -Text "$FileName" -MaxNum $Scripts.Length
        If ($OpenFromGUI) {
            Import-Module -DisableNameChecking .\"$FileName" -Force
        }
        Else {
            PowerShell -NoProfile -ExecutionPolicy Bypass -file .\"$FileName"
        }
    }

    Pop-Location

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }
}

function Open-RegFilesCollection {
    param (
        [String] $RelativeLocation,
        [Array]  $Scripts,
        [String] $DoneTitle,
        [String] $DoneMessage,
        [Parameter(Mandatory = $false)]
        [Switch] $NoDialog
    )

    Push-Location -Path "$PSScriptRoot\..\..\$RelativeLocation"

    ForEach ($FileName in $Scripts) {
        Write-TitleCounter -Text "$FileName" -MaxNum $Scripts.Length
        regedit /s "$FileName"
    }

    Pop-Location

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }
}