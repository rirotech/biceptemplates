param location string = 'eastus'
param company string
param applicationName string
param environment string
param identityName string
param useManagedIdentity string = ''

// Creating Identity
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if(empty(useManagedIdentity)){
  name: identityName
  location: location
  tags: {
    Department: company
    AppName: applicationName
    Environment: environment
  }
}

resource existingIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if(!empty(useManagedIdentity)){
  name: identityName
  }


  output identityId string = identity.id
  output identityClientId string = identity.properties.clientId
  output identityDefinition object = json('{"type":"UserAssigned","userAssignedIdentities" : {"${empty(useManagedIdentity) ? identity.id : existingIdentity.id}":{}}}')
