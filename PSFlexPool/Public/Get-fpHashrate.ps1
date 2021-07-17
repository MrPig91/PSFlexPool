function Get-fpHashrate{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string[]]$CoinTicker = @("XCH","ETH")
    )

    Process{
        foreach ($coin in $CoinTicker){
            try{
                $Query = "pool/hashrate?coin=$coin"
                $Results = Invoke-FlexPoolAPI -Query $Query
                if ($null -eq $Results.error){
                    [PSCustomObject]@{
                        Coin = $coin
                        Total = $Results.Result.total
                        Regions = $Results.Result.regions
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