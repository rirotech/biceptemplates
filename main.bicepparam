using './main.bicep'

param company = 'RRT'
param applicationName = 'WhiteLagoon'
param environment = 'dev'
param location = 'eastus'
param useManagedIdentity = ''
param workerCount = 0
param useHostingPlan = ''
param sku = 'S1'
param useAppInsights = ''
param useAppService = ''

param vNetResourceGroup = 'rg-RRT-vnet-eastus'
param subNetName = 'snet-RRT-eastus'
param vNetDepartment = 'RRT'

