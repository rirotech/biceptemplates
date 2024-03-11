@description('Department code for the group responsible for the application.')
param department string

@description('The name of the application.')
param appName string

@description('The name of the target environment (Dev/Test/Etc.).')
param environment string

@description('Location for all resources.')
param location string = 'eastus'

@description('The name of the User Managed Identity to use. Must exist. If not specified, a new instance will be created.')
param useManagedIdentity string = ''

@description('Target Worker Count.')
param workerCount int = 0

@description('The name of the existing hosting plan to use. Must exist. If not specified, a new plan will be created.')
param useHostingPlan string = '' 

@description('The pricing tier for the hosting plan.')
param sku string = 'S1'

@description('The name of the App Insights instance to use. Must exist. If not specified, a new instance will be created.')
param useAppInsights string = ''

@description('The name of the App Insights instance to use. Must exist. If not specified, a new instance will be created.')
param useAppService string = ''

@description('The name of the resource group containing the VNet to associate with.')
param vNetResourceGroup string = ''

@description('The name of the subnet on the VNet to associate with.')
param subNetName string = ''

@description('Department code for the group responsible for the application.')
param vNetDepartment string

@description('Location for all resources.')
param useVNet string  = ''

var vNetworkName = empty(useVNet) ? '${vNetDepartment}-Iaas-East' : useVNet

// var addvNet = ((!empty(vNetResourceGroup)) && (!empty(vNetName)) && (!empty(subNetName)))
// var subnetRef = resourceId(vNetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vNetName, subNetName)
var identityName = (empty(useManagedIdentity) ? '${department}-${appName}-${environment}-id' : useManagedIdentity)
var hostingPlanName =  empty(useHostingPlan) ? '${department}-${appName}-${environment}-asp': useHostingPlan

var workspaceName = '${department}-${appName}-${environment}-log'
var appInsightsName = empty(useAppInsights) ? '${department}-${appName}-${environment}-appi' : useAppInsights

var appServiceName = empty(useAppService) ? '${department}-${appName}-${environment}-app' : useAppService

module identityModule 'Identity/identity.bicep'= {
  name: identityName
  params: {
    appName: appName
    department: department
    environment: environment
    location: location
    useManagedIdentity: useManagedIdentity
    identityName: identityName
  }
}

module hostingPlanModule 'HostingPlan/hostingplan.bicep'= {
  name: hostingPlanName
  params: {
    appName: appName
    department: department
    environment: environment
    location: location   
    sku:sku     
    workerCount: workerCount
  }
}

module workspaceModule 'Workspace/workspace.bicep' = {
  name: workspaceName
  params: {
    appName: appName
    department: department
    environment: environment
    location:location
  }
}

module appInsightModule 'AppInsight/appinsight.bicep' = {
  name: appInsightsName
  params: {
    appName: appName
    department: department
    environment: environment
    location: location
    workspaceId: workspaceModule.outputs.workspaceId
  }
}

module vnetModule 'VirtualNetwork/virtualNetwork.bicep' = {
  name: vNetworkName
  params:{
    subNetName: subNetName
    location: location
    vNetDepartment: vNetDepartment
    useVNet: useVNet
  }
  scope: resourceGroup(vNetResourceGroup)
}


module appServiceModule 'AppService/AppService.bicep' = {
  name: appServiceName
  params: {
    appIdentity:  identityModule.outputs.identityClientId
    department: department
    environment: environment
    hostingPlanId: hostingPlanModule.outputs.hostingPlanId
    appInsightsInstrumentaionKey: appInsightModule.outputs.appInsightInstrumentaionKey
    appInsightsConnectionString: appInsightModule.outputs.appInsightConnectionString
    identityDefinition: identityModule.outputs.identityDefinition
    location: location
    appName: appName
    webAppName: appServiceName
    vNetworkName: vNetworkName
    vNetResourceGroup: vNetResourceGroup
    subNetName: subNetName
  }
}
