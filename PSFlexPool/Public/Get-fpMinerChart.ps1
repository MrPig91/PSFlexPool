function Get-fpMinerChart {
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
            $Query = "miner/chart?coin=$CoinTicker&address=$Address"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                $Results.result | Foreach-Object {
                    $_.psobject.TypeNames.insert(0,"PSFlexPool.MinerChart")
                    $_.TimeStamp = ConvertFrom-UNIXTime $_.TimeStamp
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