param repoUrl string
param location string

resource swa 'Microsoft.Web/staticSites@2021-03-01' = {
  name: 'swa${uniqueString(resourceGroup().id)}'
  location: location
  tags: {
    tagName1: 'demo'
  }
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    branch: 'main'
    repositoryToken: ''
    repositoryUrl: repoUrl
    buildProperties: {
      apiLocation: ''
      appLocation: '/'
      appArtifactLocation: 'dist'
    }
  }
}

output swaName string = swa.name
output deploymentToken string = swa.listSecrets().properties.apiKey
