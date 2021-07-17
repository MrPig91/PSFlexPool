function Get-fpMinerAddressCoin {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Address
    )

    Process{
        try{
            $Query = "miner/locateAddress?address=$Address"
            $Results = Invoke-FlexPoolAPI -Query $Query
            if ($null -eq $Results.error){
                [PSCustomObject]@{
                    PSTypeName = "PSFlexPool.AddressCoin"
                    Coin = $Results.result
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