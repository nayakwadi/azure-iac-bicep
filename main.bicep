targetScope = 'resourceGroup'

@minLength(3)
@maxLength(11)
param envPrefix string
param location string
param vmNameFromParams string
param vmAdminUsername string

resource KV 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: 'snvmkeyvault'
  scope: resourceGroup('snbiceprg')
}

module stgAccnt './modules/stg-accnt/stg_accnt.bicep' = {
  name: 'storageDeploy'
  params: {
    location: location
    envPrefix: envPrefix
  }
}

module nsg 'modules/nsg/nsg.bicep' = {
  name: 'nsgDeploy'
  params: {
    location: location
    envPrefix: envPrefix
  }
}

module publicIp 'modules/publicip/publicip.bicep' = {
  params: {
    location: location
    vmName: vmNameFromParams
  }
}

module vnet 'modules/vnet/vnet.bicep' = {
  name: 'VNetDeploy'
  params: {
    location: location
    envPrefix: envPrefix
    nsgId: nsg.outputs.nsgid
  }
}

module nic 'modules/nic/nic.bicep' = {
  name: 'NICdeploy'
  params: {
    location: location
    envPrefix: envPrefix
    subnetNameRef: vnet.outputs.subnetId
    publicIPAddressId: publicIp.outputs.publicipvalue
    nsgidvalue: nsg.outputs.nsgid
  }
}

module vm 'modules/vm/vm.bicep' = {
  params: {
    location: location
    envPrefix: envPrefix
    vmNameFromParams: vmNameFromParams
    adminUsername: vmAdminUsername
    nicId: nic.outputs.nicidvalue
    adminPasswordOrKey: KV.getSecret('vmPassword')
  }
}
