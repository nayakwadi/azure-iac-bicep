param envPrefix string
param location string
param nsgId string

var virtualNetworkName = '${envPrefix}vNet'
var subnetName = '${envPrefix}Subnet'
var subnetAddressPrefix = '10.1.0.0/24'
var addressPrefix = '10.1.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }
    ]
  }
}

output virtualNetworkName string = virtualNetwork.name
output virtualNetworkId string = virtualNetwork.id
output subnetName string = virtualNetwork.properties.subnets[0].name
output subnetId string = '${virtualNetwork.id}/subnets/${virtualNetwork.properties.subnets[0].name}'
