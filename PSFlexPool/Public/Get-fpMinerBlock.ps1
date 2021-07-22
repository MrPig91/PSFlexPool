function Get-fpMinerBlock {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string]$CoinTicker,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Address,
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int]$Page = 0
    )

    Process{
        try{
            $Query = "miner/blocks?coin=$CoinTicker&address=$Address&page=$Page"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                $Results.result.data | ForEach-Object {
                    $_.psobject.TypeNames.Insert(0,"PSFlexPool.MinerBlock")
                    $_.TimeStamp = ConvertFrom-UNIXTime $_.TimeStamp
                }
                [PSCustomObject]@{
                    PSTypeName = "PSFlexPool.MinerBlockPage"
                    TotalItems = $Results.result.TotalItems
                    TotalPages = $Results.result.TotalPages
                    CurrentPage = $Page
                    Blocks = $Results.result.data
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