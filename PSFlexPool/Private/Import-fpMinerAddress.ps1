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
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}