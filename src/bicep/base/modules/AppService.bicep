param location string
param appsrvplan_name string
param appsrv_name string
param aad_appid string
param aad_tenantid string
param kv_name string
param kvsecret_name_sqlcs string
param kvsecret_name_sbcs string
param sb_topic_name string

resource AppServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appsrvplan_name
  location: location
  kind: 'app'
  sku: {
    name: 'S1'
  }
}

resource AppService 'Microsoft.Web/sites@2021-02-01' = {
  name: appsrv_name
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: AppServicePlan.id
    httpsOnly: true
    siteConfig: {
      netFrameworkVersion: '6.0'
      http20Enabled: true
      minTlsVersion: '1.2'
    }
  }
}

resource AppServiceConfigCommon 'Microsoft.Web/sites/config@2021-02-01' = {
  name: '${AppService.name}/appsettings'
  properties: {
    'AzureAd:Instance': '${environment().authentication.loginEndpoint}'
    'AzureAd:ClientId': aad_appid
    'AzureAd:TenantId': aad_tenantid
    'AzureAd:CallbackPath': '/signin-oidc'
    'AllowWebApiToBeAuthorizedByACL': true
    'Sql:ConnectionString': '@Microsoft.KeyVault(VaultName=${kv_name};SecretName=${kvsecret_name_sqlcs})'
    'Servicebus:ConnectionString': '@Microsoft.KeyVault(VaultName=${kv_name};SecretName=${kvsecret_name_sbcs})'
    'Servicebus:TopicName': sb_topic_name
    'WEBSITE_RUN_FROM_PACKAGE': 1
  }
}

output AppServiceMidPrincipalId string = AppService.identity.principalId
