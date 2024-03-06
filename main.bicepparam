using './main.bicep'

param department = 'DTS'
param appName = 'PropSrch'
param environment = 'dev'
param location = 'eastus'
param useManagedIdentity = ''
param workerCount = 0
param useHostingPlan = ''
param sku = 'S1'
param useAppInsights = ''
param useAppService = ''
// param vNetResourceGroup = 'ACG-Networking-RG'


// param vNetName = 'ACG-IaaS-East'

// param subNetName = 'ACG-VNETintegration-PropertySearch-East'

// param privateEndpointVnetName = 'ACG-IaaS-East'

// param privateEndpointVnetResourceGroup = 'ACG-Networking-RG'

// param privateEndpointSubnetName = 'ACG-AzurePrivateEndpoints-East'
