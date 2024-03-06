@description('Location for all resources.')
param location string = 'eastus'

@description('Department code for the group responsible for the application.')
param department string

@description('The name of the application.')
param appName string

@description('The name of the target environment (Dev/Test/Etc.).')
param environment string

@description('The name of the App Insights instance to use. Must exist. If not specified, a new instance will be created.')
param useAppInsights string = ''

var workspaceName = '${department}-${appName}-${environment}-log'

// Creating Workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = if (empty(useAppInsights)) {
  name: workspaceName
  location: location
  properties: {}
  tags: {
    Department: department
    AppName: appName
    Environment: environment
  }
}


output workspaceId string = workspace.id
