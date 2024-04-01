param location string = 'eastus'
param company string
param applicationName string
param environment string
param useAppInsights string = ''

var workspaceName = '${company}-${applicationName}-${environment}-log'

// Creating Workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = if (empty(useAppInsights)) {
  name: workspaceName
  location: location
  properties: {}
  tags: {
    Department: company
    AppName: applicationName
    Environment: environment
  }
}


output workspaceId string = workspace.id
