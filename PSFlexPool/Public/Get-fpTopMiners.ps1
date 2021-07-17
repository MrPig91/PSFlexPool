function Get-fpTopMiners {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string[]]$CoinTicker = @("XCH","ETH")
    )

    Process{
        foreach ($coin in $CoinTicker){
            try{
                $Query = "pool/topMiners?coin=$coin"
                $Results = Invoke-FlexPoolAPI -Query $Query
                if ($null -eq $Results.error){
                    foreach ($miner in $Results.result){
                        $miner.psobject.TypeNames.Insert(0,"PSFlexPool.TopMiner")
                        $miner | Add-Member -MemberType NoteProperty -Name Coin -Value $coin
                        $miner.firstJoined = ConvertFrom-UNIXTime $miner.firstJoined
                        $miner | Add-Member -NotePropertyMembers @{
                            "Balance_$Coin" = (ConvertFrom-CoinBaseUnit $Coin -Value $miner.balance)
                        }
                        $miner
                    }
                }
                else{
                    Write-Error $Results.error -ErrorAction Stop
                }
            }
            catch{
                $PSCmdlet.WriteError($_)
            } #try/catch
        } #foreach coin
    } #Process
}