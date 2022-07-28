[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [string]
    $rgName = "Web3DevOps_dev",

    [Parameter(Position = 1)]
    [string]
    $location = "centralus",

    [string]
    $repoUrl,

    [string]
    $fqdn,

    [switch]
    $deployGanache,

    [int]
    $chainId = 1385
)

Write-Verbose $repoUrl

Write-Output 'Deploying the Azure infrastructure'
Write-Output "Deploy Ganache: $($deployGanache.IsPresent)"

$useGanache = $($deployGanache.IsPresent.ToString())

$deployment = $(az deployment sub create --name $rgName `
                --location $location `
                --template-file ./main.bicep `
                --parameters fqdn=$fqdn `
                --parameters chainId=$chainId `
                --parameters location=$location `
                --parameters rgName=$rgName `
                --parameters repoUrl=$repoUrl `
                --parameters deployGanache=$useGanache `
                --output json) | ConvertFrom-Json

# Store the outputs from the deployment
$swaName = $deployment.properties.outputs.swaName.value
$deploymentToken = $deployment.properties.outputs.deploymentToken.value

if ($deployGanache.IsPresent) {
    $ganacheIp = $deployment.properties.outputs.ganacheIp.value
    $ganacheName = $deployment.properties.outputs.ganacheName.value
    $ganacheFqdn = $deployment.properties.outputs.ganacheFqdn.value
    
    Write-Host "The IP of Ganache is http://$($ganacheIp):8545"
    Write-Host "The FQDN of Ganache is http://$($deployment.properties.outputs.ganacheFqdn.value):8545"
    Write-Host "##vso[task.setvariable variable=ganacheIp;isOutput=true]$ganacheIp"
    Write-Host "##vso[task.setvariable variable=ganacheName;isOutput=true]$ganacheName"
    Write-Host "##vso[task.setvariable variable=ganacheFqdn;isOutput=true]$ganacheFqdn"
}

# Write the values as output so they can be used in other stages.
Write-Host "##vso[task.setvariable variable=swaName;isOutput=true]$swaName"
Write-Host "##vso[task.setvariable variable=resourceGroup;isOutput=true]$rgName"
Write-Host "##vso[task.setvariable variable=deploymentToken;isOutput=true]$deploymentToken"