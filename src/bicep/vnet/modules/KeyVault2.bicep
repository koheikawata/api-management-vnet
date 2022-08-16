param location string
param tenant_id string
param aad_objectid_svc string
param kv_name string
param AppGatewayMidPrincipalId string
param AppServiceMidPrincipalId string
param FuncAppPrincipalId string
param VirtualNetwork1SubnetIdAgw string

resource KeyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: kv_name
  location: location
  properties: {
    tenantId: tenant_id
    sku: {
      name: 'standard'
      family: 'A'
    }
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: VirtualNetwork1SubnetIdAgw
        }
      ]
    }
    accessPolicies: [
      {
        tenantId: tenant_id
        objectId: aad_objectid_svc
        permissions: {
          secrets: [
            'get'
            'set'
          ]
        }
      }
      {
        tenantId: tenant_id
        objectId: AppGatewayMidPrincipalId
        permissions: {
          secrets: [
            'get'
          ]
          certificates: [
            'get'
          ]
        }
      }
      {
        tenantId: tenant_id
        objectId: AppServiceMidPrincipalId
        permissions: {
          secrets: [
            'get'
          ]
          certificates: [
            'get'
          ]
        }
      }
      {
        tenantId: tenant_id
        objectId: FuncAppPrincipalId
        permissions: {
          secrets: [
            'get'
          ]
          certificates: [
            'get'
          ]
        }
      }
    ]
  }
}

output KeyVaultName string = KeyVault.name
output KeyVaultId string = KeyVault.id
