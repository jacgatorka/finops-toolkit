# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

<#
    .SYNOPSIS
    Gets an Azure region ID and name.
    
    .PARAMETER ResouceLocation
    Optional. Resource location value from a Cost Management cost/usage details dataset. Accepts wildcards. Default = * (all).
    
    .PARAMETER RegionId
    Optional. Azure region ID (lowercase English name without spaces). Accepts wildcards. Default = * (all).
    
    .PARAMETER RegionName
    Optional. Azure region name (title case English name with spaces). Accepts wildcards. Default = * (all).

    .PARAMETER IncludeResourceLocation
    Optional. Indicates whether to include the ResourceLocation property in the output. Default = false.

    .DESCRIPTION
    The Get-FinOpsRegion command returns an Azure region ID and name based on the specified resource location.
    
    .EXAMPLE
    Get-FinOpsRegion -ResourceLocation "US East"
    
    Returns the region ID and name for the East US region.
    
    .EXAMPLE
    Get-FinOpsRegion -RegionId "*asia*" -IncludeResourceLocation
    
    Returns all Asia regions with the original Cost Management ResourceLocation value.
    
    .LINK
    https://aka.ms/ftk/Get-FinOpsRegion
#>
function Get-FinOpsRegion() {
    Param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [string]
        $ResourceLocation = "*",
        
        [Parameter()]
        [string]
        $RegionId = "*",
        
        [Parameter()]
        [string]
        $RegionName = "*",

        [switch]
        $IncludeResourceLocation
    )
    return Get-OpenDataRegions `
    | Where-Object { 
        $_.OriginalValue -like $ResourceLocation `
            -and $_.RegionId -like $RegionId `
            -and $_.RegionName -like $RegionName
    } `
    | ForEach-Object {
        [PSCustomObject]@{
            ResourceLocation = $IncludeResourceLocation ? $_.OriginalValue : $null
            RegionId         = $_.RegionId
            RegionName       = $_.RegionName
        } `
        | Select-Object -ExcludeProperty ($IncludeResourceLocation ? @() : @('ResourceLocation'))
    } `
    | Select-Object -Property * -Unique
}
