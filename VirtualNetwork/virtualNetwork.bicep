// @description('The name of the resource group containing the VNet to associate with.')
// param vNetResourceGroup string = ''

@description('The name of the subnet on the VNet to associate with.')
param subNetName string = ''

@description('Location for all resources.')
param location string = 'eastus'

@description('Location for all resources.')
param useVNet string  = ''

@description('Department code for the group responsible for the application.')
param vNetDepartment string

// var addvNet = ((!empty(vNetResourceGroup)) && (!empty(vNetName)) && (!empty(subNetName)))
// var subnetRef = resourceId(vNetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vNetName, subNetName)

var vNetworkName = empty(useVNet) ? '${vNetDepartment}-Iaas-East' : useVNet

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

// output subnetId string = vnet.properties.subnets
