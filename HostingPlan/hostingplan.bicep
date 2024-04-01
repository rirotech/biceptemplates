param location string = 'eastus'
param workerCount int = 0
param company string
param applicationName string
param environment string
param sku string = 'S1'
param useHostingPlan string = '' 

var hostingPlanName =  empty(useHostingPlan) ? '${company}-${applicationName}-${environment}-asp': useHostingPlan

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
    Department: company
    AppName: applicationName
    Environment: environment
  }
}


resource existingHostingPlan 'Microsoft.Web/serverfarms@2022-03-01' existing = if(!empty(useHostingPlan)) {
  name:useHostingPlan
}

output hostingPlanId string = newHostingPlan.id
