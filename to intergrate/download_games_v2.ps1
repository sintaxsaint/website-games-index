$repos = @(
    @{User="city41"; Repo="breakouts"; Name="breakouts"},
    @{User="operasoftware"; Repo="Emberwind"; Name="emberwind"},
    @{User="camargo"; Repo="executive-man"; Name="executive-man"},
    @{User="haxiomic"; Repo="GPU-Fluid-Experiments"; Name="fluid-table-tennis"},
    @{User="krzysztof-o"; Repo="heal-em-all"; Name="heal-em-all"},
    @{User="Q42"; Repo="0hh1"; Name="0hh1"},
    @{User="pixel-lab"; Repo="agent8ball"; Name="agent-8-ball"},
    @{User="angelnmara"; Repo="doodle-jump"; Name="doodle-jump"},
    @{User="muan"; Repo="emoji-minesweeper"; Name="minesweeper"},
    @{User="dwyl"; Repo="space-invaders"; Name="space-invaders"},
    @{User="taniarascia"; Repo="solitaire"; Name="solitaire"},
    @{User="patorjk"; Repo="JavaScript-Snake"; Name="snake"},
    @{User="jakesgordon"; Repo="javascript-tetris"; Name="javascript-tetris"},
    @{User="wayou"; Repo="t-rex-runner"; Name="t-rex-runner"},
    @{User="maming"; Repo="pacman"; Name="pacman-js"}
)

$branches = @("master", "main", "gh-pages")

foreach ($item in $repos) {
    if (Test-Path $item.Name) {
        Write-Host "$($item.Name) already exists. Skipping."
        continue
    }

    $zipFile = "$($item.Name).zip"
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

    try {
        Expand-Archive -Path $zipFile -DestinationPath "." -Force
        Remove-Item $zipFile
        
        # Find extracted folder
        $extractedFolder = Get-ChildItem -Directory | Where-Object { $_.Name -like "$($item.Repo)-*" } | Select-Object -First 1
        if ($extractedFolder) {
            Rename-Item -Path $extractedFolder.FullName -NewName $item.Name -Force
            Write-Host "Extracted and renamed to $($item.Name)"
        } else {
             Write-Host "Could not find extracted folder for $($item.Name)"
        }
    } catch {
        Write-Host "Error extracting $($item.Name): $_"
    }
}
