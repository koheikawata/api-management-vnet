param location string
param tenant_id string
param aad_objectid_svc string
param aad_secret_client string
param kv_name string
param kvsecret_name_sqlpass string
param kvsecret_name_sqlcs string
param kvsecret_name_sbcs string
param kvsecret_name_aadclient string
param kvsecret_name_azptoken string
param sqlserver_name string
param sqldb_name string
param sql_username string
param sql_pass string
param azp_token string
param AppGatewayMidPrincipalId string
param AppServiceMidPrincipalId string
param FuncAppPrincipalId string
param ServiceBusId string
param ServiceBusApiVersion string

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

resource KeyVaultSecretSqlpass 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  name: '${KeyVault.name}/${kvsecret_name_sqlpass}'
  properties: {
    value: sql_pass
  }
}

resource KeyVaultSecretSqlcs 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  name: '${KeyVault.name}/${kvsecret_name_sqlcs}'
  properties: {
    value: 'Server=tcp:${sqlserver_name}${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqldb_name};Persist Security Info=False;User ID=${sql_username};Password=${sql_pass};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
}

resource KeyVaultSecretSbcs 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  name: '${KeyVault.name}/${kvsecret_name_sbcs}'
  properties: {
    value: listKeys('${ServiceBusId}/AuthorizationRules/RootManageSharedAccessKey', ServiceBusApiVersion).primaryConnectionString
  }
}

resource KeyVaultSecretAadClient 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  name: '${KeyVault.name}/${kvsecret_name_aadclient}'
  properties: {
    value: aad_secret_client
  }
}

resource KeyVaultSecretAzpToken 'Microsoft.KeyVault/vaults/secrets@2021-10-01' = {
  name: '${KeyVault.name}/${kvsecret_name_azptoken}'
  properties: {
    value: azp_token
  }
}

output KeyVaultName string = KeyVault.name
output KeyVaultId string = KeyVault.id
