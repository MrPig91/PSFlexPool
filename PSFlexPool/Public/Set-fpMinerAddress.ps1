function Set-fpMinerAddress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]$Address
    )

    Process {
        try{
            $PSFlexPoolPath = "$ENV:LOCALAPPDATA\PSFlexPool"
            if (-not(Test-Path $PSFlexPoolPath)){
                [void](New-Item -Path $PSFlexPoolPath -ItemType Directory)
            }
            try {
                $AddressCoinPair = Get-fpMinerAddressCoin @PSBoundParameters -ErrorAction Stop
                $AddressCoinPair | Export-Clixml "$PSFlexPoolPath\SavedAddress.xml"
            }   
            catch{
                Write-Error "Unable to find address on FlexPool: $($_.Exception.Message)" -ErrorAction Stop
            }
            Import-fpMinerAddress
        }
        catch{
            $PSCmdlet.WriteError($_)            
        } #try/catch
    } #Process
}