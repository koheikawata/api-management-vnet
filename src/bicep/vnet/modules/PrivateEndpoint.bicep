param location string
param pe_name_kv string
param pe_name_sql string
param pe_name_sb string
param pe_name_ase string
param pe_name_func string
param KeyVaultId string
param SqlServerId string
param ServiceBusId string
param AppServiceId string
param FuncId string
param VirtualNetwork2SubnetIdKv string
param VirtualNetwork2SubnetIdSql string
param VirtualNetwork3SubnetIdSb string
param VirtualNetwork2SubnetIdAsePe string
param VirtualNetwork2SubnetIdFuncPe string

resource PrivateEndpointKv 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: pe_name_kv
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: pe_name_kv
        properties: {
          privateLinkServiceId: KeyVaultId
          groupIds: [
            'vault'
          ]
        }
      }
    ]
    subnet: {
      id: VirtualNetwork2SubnetIdKv
      properties: {
        privateEndpointNetworkPolicies: 'Enabled'
      }
    }
  }
}


resource PrivateEndpointSql 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: pe_name_sql
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: pe_name_sql
        properties: {
          privateLinkServiceId: SqlServerId
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
    subnet: {
      id: VirtualNetwork2SubnetIdSql
      properties: {
        privateEndpointNetworkPolicies: 'Enabled'
      }
    }
  }
}

resource PrivateEndpointSb 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: pe_name_sb
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: pe_name_sb
        properties: {
          privateLinkServiceId: ServiceBusId
          groupIds: [
            'namespace'
          ]
        }
      }
    ]
    subnet: {
      id: VirtualNetwork3SubnetIdSb
      properties: {
        privateEndpointNetworkPolicies: 'Enabled'
      }
    }
  }
}

resource PrivateEndpointAse 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: pe_name_ase
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: pe_name_ase
        properties: {
          privateLinkServiceId: AppServiceId
          groupIds: [
            'sites'
          ]
        }
      }
    ]
    subnet: {
      id: VirtualNetwork2SubnetIdAsePe
      properties: {
        privateEndpointNetworkPolicies: 'Enabled'
      }
    }
  }
}

resource PrivateEndpointFunc 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: pe_name_func
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: pe_name_func
        properties: {
          privateLinkServiceId: FuncId
          groupIds: [
            'sites'
          ]
        }
      }
    ]
    subnet: {
      id: VirtualNetwork2SubnetIdFuncPe
      properties: {
        privateEndpointNetworkPolicies: 'Enabled'
      }
    }
  }
}

output PrivateEndpointKvIpAddress string = PrivateEndpointKv.properties.customDnsConfigs[0].ipAddresses[0]
output PrivateEndpointSqlIpAddress string = PrivateEndpointSql.properties.customDnsConfigs[0].ipAddresses[0]
output PrivateEndpointSbIpAddress string = PrivateEndpointSb.properties.customDnsConfigs[0].ipAddresses[0]
output PrivateEndpointAseIpAddress string = PrivateEndpointAse.properties.customDnsConfigs[0].ipAddresses[0]
output PrivateEndpointFuncIpAddress string = PrivateEndpointFunc.properties.customDnsConfigs[0].ipAddresses[0]
