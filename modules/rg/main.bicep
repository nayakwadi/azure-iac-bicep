// set the target scope for this file
targetScope = 'subscription'

@minLength(3)
@maxLength(11)
param envPrefix string

param location string

var resourceGroupName = '${envPrefix}rg'

resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}
