function Import-fpMinerAddress {
    [CmdletBinding()]
    param()

    try{
        $AddressPath = "$ENV:LOCALAPPDATA\PSFlexPool\SavedAddress.xml"
        if (Test-Path $AddressPath){
            $AddressCoinPair = Import-Clixml $AddressPath
            Get-Command -Module PSFlexPool -ParameterName "Address" | ForEach-Object {
                try {
                    $Global:PSDefaultParameterValues["$($_.Name):Address"] = $AddressCoinPair.Address
                    $Global:PSDefaultParameterValues["$($_.Name):CoinTicker"] = $AddressCoinPair.Coin
                }
                catch{
                    Write-Warning "Unable to set default parameter value for $($_.Name)"
                }
            }
        }
        else{
            Write-Warning "No saved miner address found. Use Set-fpMinerAddress to set default address to use for Miner functions!"
        }
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}