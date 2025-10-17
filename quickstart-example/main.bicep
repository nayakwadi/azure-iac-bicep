targetScope = 'subscription'

param resourceGroupName string = 'snbiceprg'
param resourceGroupLocation string = 'eastus2'
param storageLocation string = 'eastus2'
param storageName string = 'snstgaccntbicep'

resource newRG 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

module storageAcct 'storage.bicep' = {
  name: 'storageModule'
  scope: newRG
  params: {
    storageLocation: storageLocation
    storageName: storageName
  }
}
