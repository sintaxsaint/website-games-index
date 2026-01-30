$repos = @(
    @{User="wwwtyro"; Repo="Astray"; Name="astray"},
    @{User="jakesgordon"; Repo="javascript-racer"; Name="javascript-racer"},
    @{User="daleharvey"; Repo="pacman"; Name="pacman"},
    @{User="thinkpixellab"; Repo="agent8ball"; Name="agent-8-ball"},
    @{User="dwmkerr"; Repo="spaceinvaders"; Name="space-invaders"},
    @{User="joe-gerhard"; Repo="Solitaire"; Name="solitaire"},
    @{User="Q42"; Repo="0hh1"; Name="0hh1"},
    @{User="camargo"; Repo="executive-man"; Name="executive-man"},
    @{User="krzysztof-o"; Repo="heal-em-all"; Name="heal-em-all"}
)

$branches = @("master", "main", "gh-pages")

foreach ($item in $repos) {
    if (Test-Path $item.Name) {
        Write-Host "$($item.Name) already exists. Skipping."
        continue
    }

    # Check for extracted but not renamed folder
    # Search for both Repo-branch and Repo-master patterns just in case
    $possibleExtracted = Get-ChildItem -Directory | Where-Object { $_.Name -like "$($item.Repo)-*" -or $_.Name -like "*$($item.Repo)*" } | Select-Object -First 1
    if ($possibleExtracted) {
        if ($possibleExtracted.Name -eq $item.Name) {
             Write-Host "$($item.Name) already exists (exact match). Skipping."
             continue
        }
        Write-Host "Found unrenamed folder $($possibleExtracted.Name). Renaming to $($item.Name)..."
        try {
            Rename-Item -Path $possibleExtracted.FullName -NewName $item.Name -Force
            continue
        } catch {
            Write-Host "Failed to rename $($possibleExtracted.Name). Skipping."
            continue
        }
    }

    $zipFile = "$($item.Name).zip"
    
    # Download if zip doesn't exist
    if (-not (Test-Path $zipFile)) {
        $downloaded = $false
        foreach ($branch in $branches) {
            $url = "https://github.com/$($item.User)/$($item.Repo)/archive/refs/heads/$branch.zip"
            Write-Host "Attempting to download $($item.Name) from $branch..."
            try {
                Invoke-WebRequest -Uri $url -OutFile $zipFile -ErrorAction Stop
                Write-Host "Downloaded $($item.Name) from $branch."
                $downloaded = $true
                break
            } catch {
                # Write-Host "Failed branch $branch for $($item.Name)"
            }
        }
        if (-not $downloaded) {
            Write-Host "Failed to download $($item.Name) from all branches."
            continue
        }
    } else {
        Write-Host "Zip file for $($item.Name) already exists."
    }

    # Extract
    try {
        Write-Host "Extracting $($item.Name)..."
        Expand-Archive -Path $zipFile -DestinationPath "." -Force
        
        # Give it a moment to release file handles
        Start-Sleep -Seconds 2
        
        Remove-Item $zipFile -Force
        
        # Find extracted folder again
        $extractedFolder = Get-ChildItem -Directory | Where-Object { $_.Name -like "$($item.Repo)-*" } | Select-Object -First 1
        if (-not $extractedFolder) {
             $extractedFolder = Get-ChildItem -Directory | Where-Object { $_.Name -like "*$($item.Repo)*" } | Select-Object -First 1
        }
        
        if ($extractedFolder) {
            Rename-Item -Path $extractedFolder.FullName -NewName $item.Name -Force
            Write-Host "Extracted and renamed to $($item.Name)"
        } else {
             Write-Host "Could not find extracted folder for $($item.Name)"
             Get-ChildItem -Directory | Select-Object Name
        }
    } catch {
        Write-Host "Error extracting $($item.Name): $_"
    }
}
