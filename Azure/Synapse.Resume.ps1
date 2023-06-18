# Copyright (c) 2023 Mark Broadbent under license detailed at https://github.com/retracement/Scripts/blob/main/LICENSE
# Please read and agree to these terms and conditions of use before proceeding.
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [String]
    $synapseWorkspaceName,
    [Parameter(Mandatory=$false)]
    [String]
    $subscriptionName
)

#############
# Main body #
#############
Write-Host 'Parameters...'
Write-Host $synapseWorkspaceName
Write-Host $subscriptionName

# Get subscription and select if needed
$subscription = Get-AzSubscription|where {$_.Name -eq $subscriptionName}
# Subscription selection not needed for ADO since subscription is already in context
#$subscription|Select-AzSubscription

# Search for existing synapse pool
$sqlPool = Get-AzSynapseSqlPool -WorkspaceName $synapseWorkspaceName

# Exit routine if does not exist
if(!$sqlPool){
    Write-Host 'SQL Pool not found!'
    exit
}

#Output current state
$sqlPool

$sqlPoolName = $sqlPool.Name
$sqlPoolStatus = $sqlPool.Status

if($sqlPoolStatus -eq '"Online"' -Or $sqlPoolStatus -eq '"Resuming"'){
    Write-Host 'SQL Pool is started or resuming already.'
}
else{
    Write-Host 'Resuming SQL Pool'
    Resume-AzSynapseSqlPool -WorkspaceName $synapseWorkspaceName -Name $sqlPoolName
}
