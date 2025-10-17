param location string
param envPrefix string

var networkSecurityGroupName = '${envPrefix}nsg'

// Define security rules only for non-Prod environments
var securityRules = envPrefix == 'prod'
  ? []
  : [
      {
        name: 'SSH'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: securityRules
  }
}

output nsgid string = networkSecurityGroup.id
