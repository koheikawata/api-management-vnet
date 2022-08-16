param pdns_name_kv string
param pdns_name_sql string
param pdns_name_sb string
param pdns_name_app string
param KeyVaultName string
param SqlServerName string
param ServiceBusName string
param AppServiceName string
param FuncName string
param VirtualNetwork1Id string
param VirtualNetwork2Id string
param VirtualNetwork3Id string
param PrivateEndpointKvIpAddress string
param PrivateEndpointSqlIpAddress string
param PrivateEndpointSbIpAddress string
param PrivateEndpointAseIpAddress string
param PrivateEndpointFuncIpAddress string

resource PrivateDnsKv 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: pdns_name_kv
  location: 'global'
}

resource VnetLinkKv 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsKv.name}/${PrivateDnsKv.name}-linkc'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork2Id
    }
  }
}

resource PrivateDnsAKv 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsKv.name}/${KeyVaultName}'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: PrivateEndpointKvIpAddress
      }
    ]
  }
}

resource PrivateDnsSql 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: pdns_name_sql
  location: 'global'
}

resource VnetLinkSql 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsSql.name}/${PrivateDnsSql.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork2Id
    }
  }
}

resource PrivateDnsASql 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsSql.name}/${SqlServerName}'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: PrivateEndpointSqlIpAddress
      }
    ]
  }
}

resource PrivateDnsSb 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: pdns_name_sb
  location: 'global'
}

resource VnetLinkSb2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsSb.name}/${PrivateDnsSb.name}-link2'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork2Id
    }
  }
}

resource VnetLinkSb3 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsSb.name}/${PrivateDnsSb.name}-link3'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork3Id
    }
  }
}

resource PrivateDnsASb 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsSb.name}/${ServiceBusName}'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: PrivateEndpointSbIpAddress
      }
    ]
  }
}

resource PrivateDnsApp 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: pdns_name_app
  location: 'global'
}

resource VnetLinkApp1 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsApp.name}/${PrivateDnsApp.name}-link1'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork1Id
    }
  }
}

resource VnetLinkApp2 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsApp.name}/${PrivateDnsApp.name}-link2'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork2Id
    }
  }
}

resource VnetLinkApp3 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsApp.name}/${PrivateDnsApp.name}-link3'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork3Id
    }
  }
}

resource PrivateDnsAAse 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsApp.name}/${AppServiceName}'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: PrivateEndpointAseIpAddress
      }
    ]
  }
}

resource PrivateDnsAAseScm 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsApp.name}/${AppServiceName}.scm'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: PrivateEndpointAseIpAddress
      }
    ]
  }
}

resource PrivateDnsAFunc 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsApp.name}/${FuncName}'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: PrivateEndpointFuncIpAddress
      }
    ]
  }
}

resource PrivateDnsAFuncScm 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsApp.name}/${FuncName}.scm'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: PrivateEndpointFuncIpAddress
      }
    ]
  }
}
