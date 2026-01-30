$repos = @(
    @{User="Q42"; Repo="0hh1"; Name="0hh1"},
    @{User="camargo"; Repo="executive-man"; Name="executive-man"},
    @{User="krzysztof-o"; Repo="heal-em-all"; Name="heal-em-all"},
    @{User="mgechev"; Repo="mk.js"; Name="mk.js"}
)

$branches = @("master", "main", "gh-pages")

foreach ($item in $repos) {
    if (Test-Path $item.Name) { Write-Host "$($item.Name) exists"; continue }
    
    $zip = "$($item.Name).zip"
    if (-not (Test-Path $zip)) {
        foreach ($branch in $branches) {
             $url = "https://github.com/$($item.User)/$($item.Repo)/archive/refs/heads/$branch.zip"
             Write-Host "Downloading $($item.Name) from $branch..."
             try {
                 Invoke-WebRequest -Uri $url -OutFile $zip -ErrorAction Stop
                 Write-Host "Downloaded $($item.Name)"
                 break
             } catch {
                 Write-Host "Failed $branch"
             }
        }
    }
    
    if (Test-Path $zip) {
        try {
            Expand-Archive $zip -DestinationPath "." -Force
            Remove-Item $zip -Force
            $extracted = Get-ChildItem -Directory | Where-Object { $_.Name -like "$($item.Repo)-*" -or $_.Name -like "*$($item.Repo)*" } | Select-Object -First 1
            if ($extracted) {
                Rename-Item $extracted.FullName $item.Name -Force
                Write-Host "Extracted $($item.Name)"
            } else {
                Write-Host "Could not find extracted folder for $($item.Name)"
            }
        } catch {
            Write-Host "Error extracting $($item.Name)"
        }
    }
}
