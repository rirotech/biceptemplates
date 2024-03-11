// @description('Location for all resources.')
// param location string = 'eastus'

// @description('The name of the target environment (Dev/Test/Etc.).')
// param webAppName string

// @description('The name of the target environment (Dev/Test/Etc.).')
// param identityDefinition object

// @description('Sets always on property for production slot only.')
// param alwaysOn bool = false
// param clientAffinityEnabled bool = false


// @description('The name of the target environment (Dev/Test/Etc.).')
// param appInsightsInstrumentaionKey string

// @description('The name of the target environment (Dev/Test/Etc.).')
// param appInsightsConnectionString string

// @description('Comma delimited list of the Slot Names')
// param webAppSlotList string = ''


// @description('The name of the target environment (Dev/Test/Etc.).')
// param appIdentity string

// resource webApp_resource 'Microsoft.Web/sites@2022-03-01' existing = {
//   name: webAppName
// }

// var webAppSlotNames = ((webAppSlotList == '') ? split('emptyList', ',') : split(webAppSlotList, ','))

// resource webApp_Slots 'Microsoft.Web/sites/slots@2022-03-01' = [for item in webAppSlotNames: if (webAppSlotNames[0] != 'emptyList') {
//   parent: webApp_resource
//   location:location
//   name: item
//   identity: identityDefinition
//   properties: {
//     clientAffinityEnabled: clientAffinityEnabled
//     siteConfig: {
//       alwaysOn: false
//       netFrameworkVersion: 'v4.0'
//       appSettings:[
//         {
//           name : 'APPINSIGHTS_INSTRUMENTATIONKEY'
//           value: appInsightsInstrumentaionKey
//         }
//         {
//           name : 'APPLICATIONINSIGHTS_CONNECTION_STRING'
//           value: appInsightsConnectionString
//         }
//         {
//           name : 'ApplicationInsightsAgent_EXTENSION_VERSION'
//           value: '~2'
//         }
//         {
//           name : 'AzureServicesAuthConnectionString'
//           value: 'RunAs=App;AppId=${appIdentity}'
//         }
//       ]
//   }
// }}]
// resource webApp_Slots_VNet 'Microsoft.Web/sites/slots/networkConfig@2018-11-01' = [for (item, i) in webAppSlotNames: if (webAppSlotNames[0] != 'emptyList'){
//   parent: webApp_Slots[i]
//   name: 'virtualNetwork'
//   properties: {
//     subnetResourceId: subnetRef
//     swiftSupported: true
//   }
// }
// ]

// resource webApp_Slots_AppInsights 'Microsoft.Web/sites/slots/siteextensions@2022-03-01' = [for (item, i) in webAppSlotNames: if (webAppSlotNames[0] != 'emptyList'){
//   parent: webApp_Slots[i]
//   name: 'Microsoft.ApplicationInsights.AzureWebSites'
// }
// ]
