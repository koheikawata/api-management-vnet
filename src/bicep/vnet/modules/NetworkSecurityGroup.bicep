param location string
param nsg_name_1_agw string
param nsg_name_1_apim string
param nsg_name_2_ase_vi string
param nsg_name_2_ase_pe string
param nsg_name_2_sql string
param nsg_name_2_kv string
param nsg_name_2_func_vi string
param nsg_name_2_func_pe string
param nsg_name_2_shagent string
param nsg_name_3_sb string
param snet_prefix_1_agw string

resource Nsg1Agw 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_1_agw
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Https-In'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: snet_prefix_1_agw
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'Allow-WAFV2-In'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '65200-65535'
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource Nsg1Apim 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_1_apim
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Management-In'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3443'
          sourceAddressPrefix: 'ApiManagement'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource Nsg2AseVi 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_2_ase_vi
  location: location
  properties: {
    securityRules: []
  }
}

resource Nsg2AsePe 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_2_ase_pe
  location: location
  properties: {
    securityRules: []
  }
}

resource Nsg2Sql 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_2_sql
  location: location
  properties: {
    securityRules: []
  }
}

resource Nsg2Kv 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_2_kv
  location: location
  properties: {
    securityRules: []
  }
}

resource Nsg2Shagent 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_2_shagent
  location: location
  properties: {
    securityRules: []
  }
}

resource Nsg2FuncVi 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_2_func_vi
  location: location
  properties: {
    securityRules: []
  }
}

resource Nsg2FuncPe 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_2_func_pe
  location: location
  properties: {
    securityRules: []
  }
}

resource Nsg3Sb 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsg_name_3_sb
  location: location
  properties: {
    securityRules: []
  }
}

output Nsg1AgwId string = Nsg1Agw.id
output Nsg1ApimId string = Nsg1Apim.id
output Nsg2AseViId string = Nsg2AseVi.id
output Nsg2AsePeId string = Nsg2AsePe.id
output Nsg2SqlId string = Nsg2Sql.id
output Nsg2KvId string = Nsg2Kv.id
output Nsg2FuncViId string = Nsg2FuncVi.id
output Nsg2FuncPeId string = Nsg2FuncPe.id
output Nsg2ShagentId string = Nsg2Shagent.id
output Nsg3SbId string = Nsg3Sb.id
