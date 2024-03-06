@description('Location for all resources.')
param location string = 'eastus'

@description('Department code for the group responsible for the application.')
param department string

@description('The name of the application.')
param appName string

@description('The name of the target environment (Dev/Test/Etc.).')
param environment string

@description('The name of the App Insights instance to use. Must exist. If not specified, a new instance will be created.')
param workspaceId string = ''

@description('The name of the App Insights instance to use. Must exist. If not specified, a new instance will be created.')
param useAppInsights string = ''

var appInsightsName = empty(useAppInsights) ? '${department}-${appName}-${environment}-appi' : useAppInsights


// Create App Insight
  resource appInsightsResource 'Microsoft.Insights/components@2020-02-02'= if (empty(useAppInsights)) {
    name: appInsightsName
    location: location
    kind: 'web'
    tags: {
      Department: department
      AppName: appName
      Environment: environment
    }
    properties: {
      Application_Type: 'web'
      WorkspaceResourceId: workspaceId
    }
    
  }

  resource existingAppInsights 'Microsoft.Insights/components@2020-02-02' existing  = if (!empty(useAppInsights)){
    name:useAppInsights
  }
  

  output appInsightInstrumentaionKey string = appInsightsResource.properties.InstrumentationKey
  output appInsightConnectionString string = appInsightsResource.properties.ConnectionString
