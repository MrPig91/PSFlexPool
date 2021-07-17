function ConvertFrom-UNIXTime {
    [CmdletBinding()]
    param(
        [int]$Seconds
    )
    return [DateTime]::new(1970,1,1,0,0,0,[System.DateTimeKind]::Utc).AddSeconds([int]$Seconds).ToLocalTime()
}