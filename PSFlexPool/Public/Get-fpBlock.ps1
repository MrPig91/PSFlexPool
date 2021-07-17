function Get-fpBlock {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string]$CoinTicker = "xch",
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int]$Page = 0
    )

    Process{
        try{
            $Query = "pool/blocks?coin=$CoinTicker&page=$Page"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                [PSCustomObject]@{
                    PSTypeName = "PSFlexPool.Block"
                    TotalItems = $Results.result.TotalItems
                    TotalPages = $Results.result.TotalPages
                    CurrentPage = $Page
                    Blocks = $Results.result.data
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