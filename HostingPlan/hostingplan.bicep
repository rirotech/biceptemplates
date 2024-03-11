@description('Location for all resources.')
param location string = 'eastus'

@description('Target Worker Count.')
param workerCount int = 0

@description('Department code for the group responsible for the application.')
param department string

@description('The name of the application.')
param appName string

@description('The name of the target environment (Dev/Test/Etc.).')
param environment string

@description('The pricing tier for the hosting plan.')
param sku string = 'S1'

@description('The name of the existing hosting plan to use. Must exist. If not specified, a new plan will be created.')
param useHostingPlan string = '' 

var hostingPlanName =  empty(useHostingPlan) ? '${department}-${appName}-${environment}-asp': useHostingPlan

// Creating Web Hosting Plan
resource newHostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = if(empty(useHostingPlan)) {
  name: hostingPlanName
  location: location
  sku: {
    name: sku
    capacity: workerCount
  }
  properties: {
    perSiteScaling: true 
    maximumElasticWorkerCount: workerCount
    zoneRedundant: false 
  }
  tags: {
    Department: department
    AppName: appName
    Environment: environment
  }
}


resource existingHostingPlan 'Microsoft.Web/serverfarms@2022-03-01' existing = if(!empty(useHostingPlan)) {
  name:useHostingPlan
}

output hostingPlanId string = newHostingPlan.id
