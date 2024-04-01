param subNetName string = ''
param location string = 'eastus'
param useVNet string  = ''
param vNetDepartment string

var vNetworkName = empty(useVNet) ? '${vNetDepartment}-vnet-eastus' : useVNet

resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = if(empty(useVNet)) {
  name: vNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subNetName
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: [
            {
              name: 'Microsoft.Web/serverfarms'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
        }
      }
    ]
  }
}



resource existingVNet 'Microsoft.Network/virtualNetworks@2019-11-01' existing = if(!empty(useVNet)) {
  name:useVNet
}

