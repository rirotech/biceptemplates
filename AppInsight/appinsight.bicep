param location string = 'eastus'
param company string
param applicationName string
param environment string
param workspaceId string = ''
param useAppInsights string = ''

var appInsightsName = empty(useAppInsights) ? '${company}-${applicationName}-${environment}-appi' : useAppInsights

// Create App Insight
  resource appInsightsResource 'Microsoft.Insights/components@2020-02-02'= if (empty(useAppInsights)) {
    name: appInsightsName
    location: location
    kind: 'web'
    tags: {
      Department: company
      AppName: applicationName
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
