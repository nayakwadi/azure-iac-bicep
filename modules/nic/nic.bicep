param envPrefix string
param location string
param subnetNameRef string
param publicIPAddressId string
param nsgidvalue string

var networkInterfaceName = '${envPrefix}nic'

resource networkInterface 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetNameRef
          }
          publicIPAddress: {
            id: publicIPAddressId
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgidvalue
    }
  }
}

output nicidvalue string = networkInterface.id
