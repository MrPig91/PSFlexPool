function Get-fpMinerRoundShare {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string]$CoinTicker,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Address
    )

    Process{
        try{
            $Query = "miner/roundShare?coin=$CoinTicker&address=$Address"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                [PSCustomObject]@{
                    PSTypeName = "PSFlexPool.MinerRoundShare"
                    RoundShare = $Results.result
                    Coin = $CoinTicker
                    Address = $Address
                }
            }
            else{
                Write-Error $Results.error -ErrorAction Stop
            }
        }
        catch{
            $PSCmdlet.WriteError($_)
        } #try/catch
    } #Process
}