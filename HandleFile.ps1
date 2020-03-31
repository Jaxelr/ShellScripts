[CmdletBinding()]
Param(
    # Input Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
    [string]$InputFile,

    # Output Path for the Processing Logic
    [Parameter(Mandatory=$True,Position=1)]
    [string]$OutputFile
)

$Ids = @{}

foreach($line in Get-Content $InputFile) {
    if($line -match $regex){
        
        # 
        # 
        # Do Whatever string manipulation you need with line here.
        # And add it to the hashtable.
        #
        #  
    }
}

foreach ($key in $Ids.keys) {
    Add-Content $OutputFile "$key" 
}