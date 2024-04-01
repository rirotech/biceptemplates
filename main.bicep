param company string
param applicationName string
param environment string
param location string = 'eastus'
param useManagedIdentity string = ''
param workerCount int = 0
param useHostingPlan string = '' 
param sku string = 'S1'
param useAppInsights string = ''
param useAppService string = ''
param vNetResourceGroup string = ''
param subNetName string = ''
param vNetDepartment string
param useVNet string  = ''

var vNetworkName = empty(useVNet) ? '${vNetDepartment}-vnet-eastus' : useVNet
var identityName = (empty(useManagedIdentity) ? '${company}-${applicationName}-${environment}-id' : useManagedIdentity)
var hostingPlanName =  empty(useHostingPlan) ? '${company}-${applicationName}-${environment}-asp': useHostingPlan
var workspaceName = '${company}-${applicationName}-${environment}-log'
var appInsightsName = empty(useAppInsights) ? '${company}-${applicationName}-${environment}-appi' : useAppInsights
var appServiceName = empty(useAppService) ? '${company}-${applicationName}-${environment}-app' : useAppService

module identityModule 'Identity/identity.bicep'= {
  name: identityName
  params: {
    applicationName: applicationName
    company: company
    environment: environment
    location: location
    useManagedIdentity: useManagedIdentity
    identityName: identityName
  }
}

module hostingPlanModule 'HostingPlan/hostingplan.bicep'= {
  name: hostingPlanName
  params: {
    applicationName: applicationName
    company: company
    environment: environment
    location: location   
    sku:sku     
    workerCount: workerCount
  }
}

module workspaceModule 'Workspace/workspace.bicep' = {
  name: workspaceName
  params: {
    applicationName: applicationName
    company: company
    environment: environment
    location:location
  }
}

module appInsightModule 'AppInsight/appinsight.bicep' = {
  name: appInsightsName
  params: {
    applicationName: applicationName
    company: company
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
    company: company
    environment: environment
    hostingPlanId: hostingPlanModule.outputs.hostingPlanId
    appInsightsInstrumentaionKey: appInsightModule.outputs.appInsightInstrumentaionKey
    appInsightsConnectionString: appInsightModule.outputs.appInsightConnectionString
    identityDefinition: identityModule.outputs.identityDefinition
    location: location
    applicationName: applicationName
    webAppName: appServiceName
    vNetworkName: vNetworkName
    vNetResourceGroup: vNetResourceGroup
    subNetName: subNetName
  }
}
