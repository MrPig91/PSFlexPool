function Get-fpCoins {
    [CmdletBinding()]
    param()

    try{
        $Results = Invoke-FlexPoolAPI -Query "pool/coins"
        if ($null -eq $Results.error){
            Write-Information "Got results back"
            foreach ($coin in $Results.Result.Coins){
                $coin.psobject.TypeNames.Insert(0,"PSFlexPool.Coin")
                $coin
            } #foreach
        } #if
        else{
            Write-Error $Results.Error -ErrorAction Stop
        } #else
    }
    catch{
        $PSCmdlet.WriteError($_)
    } #try/catch
}