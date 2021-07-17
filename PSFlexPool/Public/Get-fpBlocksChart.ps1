function Get-fpBlocksChart {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string[]]$CoinTicker = @("XCH","ETH")
    )

    Process{
        foreach ($coin in $CoinTicker){
            try{
                $Query = "pool/blocksChart?coin=$coin"
                $Results = Invoke-FlexPoolAPI -Query $Query
                if ($null -eq $Results.error){
                    foreach ($blockchart in $Results.result){
                        $blockchart.psobject.TypeNames.Insert(0,"PSFlexPool.BlockChart")
                        $blockchart.TimeStamp = ConvertFrom-UNIXTime $blockchart.TimeStamp
                        $blockchart | Add-Member -MemberType NoteProperty -Name Coin -Value $coin
                        $blockchart
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