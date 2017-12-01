Param(
    [parameter(Mandatory = $true)] [string] $ClusterCIDR,
    [parameter(Mandatory = $true)] [int] $counter
    )

$mip = gc c:\k\masterip
c:\k\AddRoutes.ps1 -MasterIp $mip -Gateway "$ClusterCIDR.$counter.2"