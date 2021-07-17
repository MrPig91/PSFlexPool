function Get-fpBlockByHash {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [ValidateSet("XCH","ETH")]
        [string]$CoinTicker = "xch",

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Hash")]
        [string]$Blockhash
    )

    Process{
        try{
            $Query = "pool/blockByHash?coin=$CoinTicker&blockHash=$BlockHash"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                $Results.result.psobject.TypeNames.Insert(0,"PSFlexPool.Block")
                $Results.result.TimeStamp = ConvertFrom-UNIXTime $Results.result.TimeStamp
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