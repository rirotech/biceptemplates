@description('Location for all resources.')
param location string = 'eastus'

@description('Department code for the group responsible for the application.')
param department string

@description('The name of the application.')
param appName string

@description('The name of the target environment (Dev/Test/Etc.).')
param environment string

@description('The name of the App Insights instance to use. Must exist. If not specified, a new instance will be created.')
param useAppService string = ''

@description('The name of the target environment (Dev/Test/Etc.).')
param identityDefinition object

@description('The name of the target environment (Dev/Test/Etc.).')
param hostingPlanId string

@description('The name of the target environment (Dev/Test/Etc.).')
param appIdentity string

@description('The name of the target environment (Dev/Test/Etc.).')
param appInsightsInstrumentaionKey string

@description('The name of the target environment (Dev/Test/Etc.).')
param appInsightsConnectionString string

@description('The name of the target environment (Dev/Test/Etc.).')
param webAppName string

@description('Sets always on property for production slot only.')
param alwaysOn bool = false
param clientAffinityEnabled bool = false

@description('The name of the resource group containing the VNet to associate with.')
param vNetResourceGroup string = ''

@description('The name of the subnet on the VNet to associate with.')
param subNetName string = ''

// @description('Location for all resources.')
// param useVNet string  = ''

@description('Location for all resources.')
param vNetworkName string  = ''

// @description('Department code for the group responsible for the application.')
// param vNetDepartment string

// var vNetworkName = empty(useVNet) ? '${vNetDepartment}-Iaas-East' : useVNet

var addvNet = ((!empty(vNetResourceGroup)) && (!empty(vNetworkName)) && (!empty(subNetName)))
var subnetRef = resourceId(vNetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vNetworkName, subNetName)

var vNetRef = [
  {
    ipAddress: 'Any'
    action: 'Deny'
    priority: 2147483647
    name: 'Deny all'
    description: 'Deny all access'
  }
]


 // Create App Service
  resource webApp 'Microsoft.Web/sites@2022-03-01' = if (empty(useAppService)){
    name: webAppName
    location: location
    identity: identityDefinition
    kind: 'app'
    properties: {
      enabled: true
      serverFarmId: hostingPlanId
      clientAffinityEnabled: clientAffinityEnabled
      httpsOnly: true
      siteConfig: {
        alwaysOn: alwaysOn
        netFrameworkVersion: 'v4.0'
        appSettings:[
          {
            name : 'APPINSIGHTS_INSTRUMENTATIONKEY'
            value: appInsightsInstrumentaionKey
          }
          {
            name : 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: appInsightsConnectionString
          }
          {
            name : 'ApplicationInsightsAgent_EXTENSION_VERSION'
            value: '~2'
          }
          {
            name : 'AzureServicesAuthConnectionString'
            value: 'RunAs=App;AppId=${appIdentity}'
          }
        ]
        ipSecurityRestrictions: (false ? vNetRef : null)
        minTlsVersion: '1.2'
      }
    }
    tags: {
      Department: department
      AppName: appName
      Environment: environment
    }
  }

  
  resource existingWebApp 'Microsoft.Web/sites@2022-03-01' existing  = if (!empty(useAppService)){
    name:useAppService
  }
  
  resource webApp_AppInsights 'Microsoft.Web/sites/siteextensions@2022-03-01' = {
    parent: webApp
    name: 'Microsoft.ApplicationInsights.AzureWebSites'
  
  }


  resource webAppName_virtualNetwork 'Microsoft.Web/sites/networkConfig@2018-11-01' = if (addvNet) {
    parent: webApp
    name: 'virtualNetwork'
    properties: {
      subnetResourceId: subnetRef
      swiftSupported: true 
    }
  }
  