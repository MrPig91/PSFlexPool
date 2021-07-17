function Get-fpMinerRoundShareByBlock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string]$CoinTicker,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Address,
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Hash")]
        [string]$BlockHash
    )

    Process{
        try{
            $Query = "miner/roundShareAt?coin=$CoinTicker&address=$Address"
            if ($PSBoundParameters.ContainsKey("BlockHash")){
                $Query += "&blockHash=$BlockHash"
            }
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                if ($PSBoundParameters.ContainsKey("BlockHash")){
                    [PSCustomObject]@{
                        PSTypeName = "PSFlexPool.MinerRoundShareByBlock"
                        RoundShare = $Results.result.roundShare
                        RewardShare = $Results.result.rewardShare
                        Coin = $CoinTicker
                        Address = $Address
                    }
                }
                else{
                    [PSCustomObject]@{
                        PSTypeName = "PSFlexPool.MinerRoundShareByBlock"
                        RoundShare = $Results.result
                        RewardShare = $null
                        Coin = $CoinTicker
                        Address = $Address
                    }
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