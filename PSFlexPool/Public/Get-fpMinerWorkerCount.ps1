function Get-fpMinerWorkerCount {
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
            $Query = "miner/workerCount?coin=$CoinTicker&address=$Address"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                [PSCustomObject]@{
                    PSTypeName = "PSFlexPool.MinerWorkerCount"
                    WorkersOnline = $Results.result.WorkersOnline
                    WorkersOffline = $Results.result.WorkersOffline
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