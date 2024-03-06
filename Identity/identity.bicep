@description('Location for all resources.')
param location string = 'eastus'

@description('Department code for the group responsible for the application.')
param department string

@description('The name of the application.')
param appName string

@description('The name of the target environment (Dev/Test/Etc.).')
param environment string

@description('The name of the target environment (Dev/Test/Etc.).')
param identityName string

@description('The name of the User Managed Identity to use. Must exist. If not specified, a new instance will be created.')
param useManagedIdentity string = ''

// var identityDefinition = json('{"type":"UserAssigned","userAssignedIdentities" : {"${empty(useManagedIdentity) ? identity.id : existingIdentity.id}":{}}}')
// var appIdentity = (empty(useManagedIdentity) ? identity : existingIdentity)

// Creating Identity
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if(empty(useManagedIdentity)){
  name: identityName
  location: location
  tags: {
    Department: department
    AppName: appName
    Environment: environment
  }
}

resource existingIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if(!empty(useManagedIdentity)){
  name: identityName
  }


  output identityId string = identity.id
  output identityClientId string = identity.properties.clientId
  output identityDefinition object = json('{"type":"UserAssigned","userAssignedIdentities" : {"${empty(useManagedIdentity) ? identity.id : existingIdentity.id}":{}}}')
