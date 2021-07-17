function Get-fpMinerPaymentsStats {
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
        [string]$CounterValue = "USD"
    )

    Process{
        try{
            $Query = "miner/paymentsStats?coin=$CoinTicker&address=$Address&countervalue=$CounterValue"
            $Results = Invoke-FlexPoolAPI -Query $Query -ErrorAction Stop
            
            if ($null -eq $Results.error){
                $Results.result.lastpayment = ConvertFrom-UNIXTime $Results.result.lastpayment
                $Results.result | Add-Member -NotePropertyMembers @{
                    PSTypeName = "PSFlexPool.MinerPaymentsStats"
                    Coin = $CoinTicker
                    Address = $Address
                }
                $Results.result
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