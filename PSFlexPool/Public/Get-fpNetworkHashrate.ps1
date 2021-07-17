function Get-fpNetworkHashrate{
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string[]]$CoinTicker = @("XCH","ETH")
    )

    Process{
        foreach ($coin in $CoinTicker){
            try{
                $Query = "pool/networkHashrate?coin=$coin"
                $Results = Invoke-FlexPoolAPI -Query $Query
                if ($null -eq $Results.error){
                    [PSCustomObject]@{
                        Coin = $coin
                        NetworkHashrate = [decimal]$Results.result
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