function Get-fpMinerPayment {
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
        [string]$CounterValue = "USD",
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int]$Page = 0
    )

    Process{
        try{
            $Query = "miner/payments?coin=$CoinTicker&address=$Address&countervalue=$CounterValue&page=$Page"
            $Results = Invoke-FlexPoolAPI -Query $Query -ErrorAction Stop
            if ($null -eq $Results.error){
                $Results.result.data | ForEach-Object {
                    $_.psobject.TypeNames.Insert(0,"PSFlexPool.MinerPayment")
                    $_.TimeStamp = ConvertFrom-UNIXTime $_.TimeStamp
                    $_.ConfirmedTimeStamp = ConvertFrom-UNIXTime $_.ConfirmedTimeStamp
                    $_.duration = New-TimeSpan -Seconds $_.duration
                    $FiatPayment = [math]::Round($Results.result.countervalue * (ConvertFrom-CoinBaseUnit -CoinTicker 'XCH' -Value $_.value),2)
                    $_ | Add-Member -MemberType NoteProperty -Name "FiatValue" -Value $FiatPayment
                }
                [PSCustomObject]@{
                    PSTypeName = "PSFlexPool.MinerPaymentPage"
                    TotalItems = $Results.result.TotalItems
                    TotalPages = $Results.result.TotalPages
                    Payments = $Results.result.data
                    CounterValue = $Results.result.countervalue
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