function Invoke-FlexPoolAPI {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Query
    )

    try{
        $BaseURL = "https://api.flexpool.io/v2/"
        $RestMethodParameters = @{
            Uri = $BaseURL + $Query
            Method = "GET"
        }
        Invoke-RestMethod @RestMethodParameters
    }
    catch{
        $PSCmdlet.WriteError($_)
    } #try/catch
}