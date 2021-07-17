function Get-fpMinerStats {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string]$CoinTicker,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Address
    )

    Process{
        try{
            $Query = "miner/stats?coin=$CoinTicker&address=$Address"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                $Results.result.psobject.TypeNames.insert(0,"PSFlexPool.MinerStats")
                $Results.result | Add-Member -NotePropertyMembers @{
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