# Rename folders
if (Test-Path "agent8ball-master") { Rename-Item "agent8ball-master" "agent-8-ball" -Force; Write-Host "Renamed agent8ball" }
if (Test-Path "Solitaire-master") { Rename-Item "Solitaire-master" "solitaire" -Force; Write-Host "Renamed solitaire" }

# Check missing
$repos = @(
    @{User="Q42"; Repo="0hh1"; Name="0hh1"},
    @{User="camargo"; Repo="executive-man"; Name="executive-man"},
    @{User="krzysztof-o"; Repo="heal-em-all"; Name="heal-em-all"}
)

$branches = @("master", "main", "gh-pages")

foreach ($item in $repos) {
    if (Test-Path $item.Name) { Write-Host "$($item.Name) exists"; continue }
    
    # Check for extracted but not renamed
    $possible = Get-ChildItem -Directory | Where-Object { $_.Name -like "$($item.Repo)-*" } | Select-Object -First 1
    if ($possible) {
        Rename-Item $possible.FullName $item.Name -Force
        Write-Host "Renamed $($possible.Name) to $($item.Name)"
        continue
    }

    $zip = "$($item.Name).zip"
    if (-not (Test-Path $zip)) {
        foreach ($branch in $branches) {
             $url = "https://github.com/$($item.User)/$($item.Repo)/archive/refs/heads/$branch.zip"
             try {
                 Invoke-WebRequest -Uri $url -OutFile $zip -ErrorAction Stop
                 Write-Host "Downloaded $($item.Name)"
                 break
             } catch {}
        }
    }
    
    if (Test-Path $zip) {
        Expand-Archive $zip -DestinationPath "." -Force
        Remove-Item $zip -Force
        $extracted = Get-ChildItem -Directory | Where-Object { $_.Name -like "$($item.Repo)-*" -or $_.Name -like "*$($item.Repo)*" } | Select-Object -First 1
        if ($extracted) {
            Rename-Item $extracted.FullName $item.Name -Force
            Write-Host "Extracted $($item.Name)"
        }
    }
}
