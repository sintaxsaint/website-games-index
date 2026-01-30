$repos = @(
    @{User="city41"; Repo="breakout"; Name="breakout"},
    @{User="city41"; Repo="color-quest"; Name="color-quest"},
    @{User="city41"; Repo="drill-bunny"; Name="drill-bunny"},
    @{User="MattSurabian"; Repo="DuckHunt-JS"; Name="duckhunt"},
    @{User="operasoftware"; Repo="Emberwind"; Name="emberwind"},
    @{User="camargo"; Repo="executive-man"; Name="executive-man"},
    @{User="haxiomic"; Repo="fluid-table-tennis"; Name="fluid-table-tennis"},
    @{User="krzysztof-o"; Repo="heal-em-all"; Name="heal-em-all"},
    @{User="Q42"; Repo="0hh1"; Name="0hh1"},
    @{User="pixel-lab"; Repo="agent8ball"; Name="agent-8-ball"},
    @{User="angelnmara"; Repo="doodle-jump"; Name="doodle-jump"},
    @{User="muan"; Repo="emoji-minesweeper"; Name="minesweeper"},
    @{User="dwyl"; Repo="space-invaders"; Name="space-invaders"},
    @{User="taniarascia"; Repo="solitaire"; Name="solitaire"},
    @{User="patorjk"; Repo="JavaScript-Snake"; Name="snake"}
)

foreach ($item in $repos) {
    $urlMaster = "https://github.com/$($item.User)/$($item.Repo)/archive/refs/heads/master.zip"
    $urlMain = "https://github.com/$($item.User)/$($item.Repo)/archive/refs/heads/main.zip"
    $zipFile = "$($item.Name).zip"
    
    Write-Host "Attempting to download $($item.Name)..."
    
    try {
        Invoke-WebRequest -Uri $urlMaster -OutFile $zipFile -ErrorAction Stop
        Write-Host "Downloaded $($item.Name) from master branch."
    } catch {
        try {
            Invoke-WebRequest -Uri $urlMain -OutFile $zipFile -ErrorAction Stop
            Write-Host "Downloaded $($item.Name) from main branch."
        } catch {
            Write-Host "Failed to download $($item.Name). Skipping."
            continue
        }
    }

    try {
        Expand-Archive -Path $zipFile -DestinationPath "." -Force
        Remove-Item $zipFile
        
        # GitHub zips extract to Repo-branch folder. We need to find it and rename/move contents.
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
