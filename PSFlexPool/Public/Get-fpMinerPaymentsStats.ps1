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
                $paymentStats = $Results.result
                if ($null -ne $paymentStats.stats){
                    $paymentStats.lastpayment.timestamp = ConvertFrom-UNIXTime $paymentStats.lastpayment.timestamp
                    $paymentStats.lastpayment.duration = New-TimeSpan -Seconds $paymentStats.lastpayment.duration
                    $paymentStats.stats.averageDuration = New-TimeSpan -Seconds $paymentStats.stats.averageDuration
                    $FiatPayment = [math]::Round($paymentStats.countervalue * (ConvertFrom-CoinBaseUnit -CoinTicker 'XCH' -Value $paymentStats.lastpayment.value),2)
                    $totalfiatpaid = [math]::Round($paymentStats.countervalue * (ConvertFrom-CoinBaseUnit -CoinTicker 'XCH' -Value $paymentStats.stats.totalpaid),2)
                    $paymentStats.lastpayment | Add-Member -MemberType NoteProperty -Value $FiatPayment -Name "FiatValue"
                    $paymentStats.stats | Add-Member -MemberType NoteProperty -Name "TotalFiatPaid" -Value $totalfiatpaid
                }
                $paymentStats | Add-Member -NotePropertyMembers @{
                    PSTypeName = "PSFlexPool.MinerPaymentsStats"
                    Coin = $CoinTicker
                    Address = $Address
                }
                $paymentStats
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