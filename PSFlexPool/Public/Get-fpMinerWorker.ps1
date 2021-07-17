function Get-fpMinerWorker {
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
        [Alias("Name","Worker")]
        [string]$WorkerName
    )

    Process{
        try{
            $Query = "miner/workers?coin=$CoinTicker&address=$Address"
            if ($PSBoundParameters.ContainsKey("WorkerName")){
                $Query += "&worker=$WorkerName"
            }
            $Results = Invoke-FlexPoolAPI -Query $Query -ErrorAction Stop
            if ($null -eq $Results.error){
                $Results.result | ForEach-Object {
                    $_.psobject.TypeNames.insert(0,"PSFlexPool.MinerWorker")
                    $_.lastSeen = ConvertFrom-UNIXTime $_.lastSeen
                }
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