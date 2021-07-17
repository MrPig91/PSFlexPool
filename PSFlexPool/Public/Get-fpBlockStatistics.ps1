function Get-fpBlockStatistics {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string[]]$CoinTicker = @("XCH","ETH")
    )

    Process{
        foreach ($coin in $CoinTicker){
            try{
                $Query = "pool/blockStatistics?coin=$coin"
                $Results = Invoke-FlexPoolAPI -Query $Query
                if ($null -eq $Results.error){
                    foreach ($blockstat in $Results.result){
                        $blockstat.psobject.TypeNames.Insert(0,"PSFlexPool.BlockStatistic")
                        $blockstat | Add-Member -MemberType NoteProperty -Name Coin -Value $coin
                        $blockstat
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