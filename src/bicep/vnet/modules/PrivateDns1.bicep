param pdns_name_apim string
param ApiManagementName string
param ApiManagementPrivateIPAddress string
param VirtualNetwork1Id string

resource PrivateDnsApim 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: pdns_name_apim
  location: 'global'
}

resource VnetLinkApim 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${PrivateDnsApim.name}/${PrivateDnsApim.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: VirtualNetwork1Id
    }
  }
}

resource PrivateDnsAApim 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  name: '${PrivateDnsApim.name}/${ApiManagementName}'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: ApiManagementPrivateIPAddress
      }
    ]
  }
}
