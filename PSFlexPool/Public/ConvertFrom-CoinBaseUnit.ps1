function ConvertFrom-CoinBaseUnit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [Alias("Coin")]
        [string]$CoinTicker,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("Reward","Balance")]
        $Value
    )

    Process{
        if ($CoinTicker -eq "XCH"){
            $Value / [math]::Pow(10,12)
        }
        else{
            $Value / [math]::Pow(10,18)
        }
    }
}