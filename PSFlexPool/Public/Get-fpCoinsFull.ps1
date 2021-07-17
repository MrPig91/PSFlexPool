function Get-fpCoinsFull {
    [CmdletBinding()]
    param()

    try{
        $Results = Invoke-FlexPoolAPI -Query "pool/coinsFull"
        if ($null -eq $Results.error){
            Write-Information "Got results back"
            $Results.result | ForEach-Object {
                $_.psobject.TypeNames.Insert(0,"PSFlexPool.CoinFull")
                $_
            }
        } #if
        else{
            Write-Error $Results.Error -ErrorAction Stop
        } #else
    }
    catch{
        $PSCmdlet.WriteError($_)
    } #try/catch
}