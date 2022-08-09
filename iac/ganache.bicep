param chainId int
param fqdn string
param location string

resource ganache 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
  name: 'ganache${uniqueString(resourceGroup().id)}'
  location: location
  tags: {
    tagName1: 'demo'
  }
  properties: {
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: fqdn
      ports: [
        {
          port: 8545
          protocol: 'TCP'
        }
      ]
    }
    containers: [
      {
        name: 'ganache'
        properties: {
          command: [
            'node'
            '/app/dist/node/cli.js'
            '--wallet.totalAccounts'
            '4'
            '--wallet.deterministic'
            '--chain.chainId'
            '${chainId}'
          ]
          image: 'trufflesuite/ganache:latest'
          ports: [
            {
              port: 8545
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: json('1.5')
            }
          }
        }
      }
    ]
  }
}

output ganacheName string = ganache.name
output ganacheIp string = ganache.properties.ipAddress.ip
output ganacheFqdn string = ganache.properties.ipAddress.fqdn
