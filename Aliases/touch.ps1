function Touch-File() {
    $fileName = $args[0]
    # Check of the argument is not empty
    if (!$fileName) {
        Write-Error "First Argument must not be empty."
    }
    else {
        # Check if the file exists
        if (-not(Test-Path $fileName)) {
            # It does not exist. Create it
            New-Item -ItemType File -Name $fileName
        }
        else {
            #It exists. Update the timestamp
            (Get-ChildItem $fileName).LastWriteTime = Get-Date
        }
    }
}

### Create an alias for touch

# Check if the alias exists
if (-not(Test-Path -Path Alias:touch)) {
    New-Alias -Name touch Touch-File -Force
    Write-Host "Alias Touch created."
}