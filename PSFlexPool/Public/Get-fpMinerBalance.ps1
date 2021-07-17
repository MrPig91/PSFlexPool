function Get-fpMinerBalance {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string]$CoinTicker,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Address,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$CounterValue = "USD"
    )

    Process{
        try{
            $Query = "miner/balance?coin=$CoinTicker&address=$Address&countervalue=$CounterValue"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                [PSCustomObject]@{
                    PSTypeName = "PSFlexPool.MinerBalance"
                    Balance = $Results.result.balance
                    $CounterValue = $Results.result.balancecountervalue
                    Price = $Results.result.price
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