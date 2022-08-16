param location string
param tenant_id string
param aad_name_svc string
param aad_objectid_svc string
param sqlserver_name string
param sqldb_name string
param sql_username string
param sql_pass string

resource SqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlserver_name
  location: location
  properties: {
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    administratorLogin: sql_username
    administratorLoginPassword: sql_pass
    administrators: {
      administratorType: 'ActiveDirectory'
      login: aad_name_svc
      sid: aad_objectid_svc
      tenantId: tenant_id
      azureADOnlyAuthentication: false
    }
  }
}

resource SqlDb 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${SqlServer.name}/${sqldb_name}'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

output SqlServerName string = SqlServer.name
output SqlServerId string = SqlServer.id
