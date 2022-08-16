param location string
param vnet_name_1 string
param vnet_name_2 string
param vnet_name_3 string
param snet_name_1_agw string
param snet_name_1_apim string
param snet_name_2_ase_vi string
param snet_name_2_ase_pe string
param snet_name_2_sql string
param snet_name_2_kv string
param snet_name_2_func_vi string
param snet_name_2_func_pe string
param snet_name_2_shagent string
param snet_name_3_sb string
param vnet_ipprefix_1 string
param vnet_ipprefix_2 string
param vnet_ipprefix_3 string
param snet_prefix_1_agw string
param snet_prefix_1_apim string
param snet_prefix_2_ase_vi string
param snet_prefix_2_ase_pe string
param snet_prefix_2_sql string
param snet_prefix_2_kv string
param snet_prefix_2_func_vi string
param snet_prefix_2_func_pe string
param snet_prefix_2_shagent string
param snet_prefix_3_sb string
param vnetpeer_name_23 string
param vnetpeer_name_32 string
param vnetpeer_name_12 string
param vnetpeer_name_21 string
param Nsg1AgwId string
param Nsg1ApimId string
param Nsg2AseViId string
param Nsg2AsePeId string
param Nsg2SqlId string
param Nsg2KvId string
param Nsg2FuncViId string
param Nsg2FuncPeId string
param Nsg2ShagentId string
param Nsg3SbId string

resource VirtualNetwork1 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnet_name_1
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet_ipprefix_1
      ]
    }
    subnets: [
      {
        name: snet_name_1_agw
        properties: {
          addressPrefix: snet_prefix_1_agw
          networkSecurityGroup: {
            id: Nsg1AgwId
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
              locations: [
                '*'
              ]
            }
          ]
        }
      }
      {
        name: snet_name_1_apim
        properties: {
          addressPrefix: snet_prefix_1_apim
          networkSecurityGroup: {
            id: Nsg1ApimId
          }
        }
      }
    ]
  }
}

resource VirtualNetwork2 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnet_name_2
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet_ipprefix_2
      ]
    }
    subnets: [
      {
        name: snet_name_2_ase_vi
        properties: {
          addressPrefix: snet_prefix_2_ase_vi
          networkSecurityGroup: {
            id: Nsg2AseViId
          }
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: snet_name_2_ase_pe
        properties: {
          addressPrefix: snet_prefix_2_ase_pe
          networkSecurityGroup: {
            id: Nsg2AsePeId
          }
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: snet_name_2_sql
        properties: {
          addressPrefix: snet_prefix_2_sql
          networkSecurityGroup: {
            id: Nsg2SqlId
          }
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: snet_name_2_kv
        properties: {
          addressPrefix: snet_prefix_2_kv
          networkSecurityGroup: {
            id: Nsg2KvId
          }
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: snet_name_2_func_vi
        properties: {
          addressPrefix: snet_prefix_2_func_vi
          networkSecurityGroup: {
            id: Nsg2FuncViId
          }
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: snet_name_2_func_pe
        properties: {
          addressPrefix: snet_prefix_2_func_pe
          networkSecurityGroup: {
            id: Nsg2FuncPeId
          }
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
      {
        name: snet_name_2_shagent
        properties: {
          addressPrefix: snet_prefix_2_shagent
          networkSecurityGroup: {
            id: Nsg2ShagentId
          }
          delegations: [
            {
              name: 'ACIDelegationService'
              properties: {
                serviceName: 'Microsoft.ContainerInstance/containerGroups'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource VirtualNetwork3 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnet_name_3
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet_ipprefix_3
      ]
    }
    subnets: [
      {
        name: snet_name_3_sb
        properties: {
          addressPrefix: snet_prefix_3_sb
          networkSecurityGroup: {
            id: Nsg3SbId
          }
          privateEndpointNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

resource VnetPeering23 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-03-01' = {
  name: '${VirtualNetwork2.name}/${vnetpeer_name_23}'
  properties: {
    remoteVirtualNetwork: {
      id: VirtualNetwork3.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource VnetPeering32 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-03-01' = {
  name: '${VirtualNetwork3.name}/${vnetpeer_name_32}'
  properties: {
    remoteVirtualNetwork: {
      id: VirtualNetwork2.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource VnetPeering12 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-03-01' = {
  name: '${VirtualNetwork1.name}/${vnetpeer_name_12}'
  properties: {
    remoteVirtualNetwork: {
      id: VirtualNetwork2.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource VnetPeering21 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-03-01' = {
  name: '${VirtualNetwork2.name}/${vnetpeer_name_21}'
  properties: {
    remoteVirtualNetwork: {
      id: VirtualNetwork1.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

output VirtualNetwork1Id string = VirtualNetwork1.id
output VirtualNetwork2Id string = VirtualNetwork2.id
output VirtualNetwork3Id string = VirtualNetwork3.id
output VirtualNetwork1SubnetIdAgw string = VirtualNetwork1.properties.subnets[0].id
output VirtualNetwork1SubnetIdApim string = VirtualNetwork1.properties.subnets[1].id
output VirtualNetwork2SubnetIdAseVi string = VirtualNetwork2.properties.subnets[0].id
output VirtualNetwork2SubnetIdAsePe string = VirtualNetwork2.properties.subnets[1].id
output VirtualNetwork2SubnetIdSql string = VirtualNetwork2.properties.subnets[2].id
output VirtualNetwork2SubnetIdKv string = VirtualNetwork2.properties.subnets[3].id
output VirtualNetwork2SubnetIdFuncVi string = VirtualNetwork2.properties.subnets[4].id
output VirtualNetwork2SubnetIdFuncPe string = VirtualNetwork2.properties.subnets[5].id
output VirtualNetwork2SubnetIdShagent string = VirtualNetwork2.properties.subnets[6].id
output VirtualNetwork3SubnetIdSb string = VirtualNetwork3.properties.subnets[0].id
