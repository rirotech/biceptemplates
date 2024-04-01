param location string = 'eastus'
param company string
param applicationName string
param environment string
param useAppService string = ''
param identityDefinition object
param hostingPlanId string
param appIdentity string
param appInsightsInstrumentaionKey string
param appInsightsConnectionString string
param webAppName string
param alwaysOn bool = false
param clientAffinityEnabled bool = false
param vNetResourceGroup string = ''
param subNetName string = ''
param vNetworkName string  = ''

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
      Department: company
      AppName: applicationName
      Environment: environment
    }
  }

  
  resource existingWebApp 'Microsoft.Web/sites@2022-03-01' existing  = if (!empty(webApp)){
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
  