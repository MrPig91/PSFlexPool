function Get-fpMinersDistribution {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string[]]$CoinTicker = @("XCH","ETH")
    )

    Process{
        foreach ($coin in $CoinTicker){
            try{
                $Query = "pool/minersDistribution?coin=$coin"
                $Results = Invoke-FlexPoolAPI -Query $Query
                if ($null -eq $Results.error){
                    foreach ($minerdistribution in $Results.result){
                        $minerdistribution.psobject.TypeNames.Insert(0,"PSFlexPool.MinerDistribution")
                        $minerdistribution | Add-Member -MemberType NoteProperty -Name Coin -Value $coin
                        $minerdistribution
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