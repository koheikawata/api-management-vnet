param location string
param funcplan_name string
param func_name string
param func_storage_name string
param func_insight_name string
param sb_topic_name string
param sb_subscr_name string
param kv_name string
param kvsecret_name_sbcs string
param kvsecret_name_sqlcs string

resource FuncAppPlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: funcplan_name
  location: location
  kind: 'functionapp'
  sku: {
    name: 'S1'
  }
}

resource FuncApp 'Microsoft.Web/sites@2021-02-01' = {
  name: func_name
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: FuncAppPlan.id
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      http20Enabled: true
    }
  }
}

resource FuncConfig 'Microsoft.Web/sites/config@2021-02-01' = {
  name: '${FuncApp.name}/appsettings'
  properties: {
    'FUNCTIONS_EXTENSION_VERSION': '~4'
    'WEBSITE_RUN_FROM_PACKAGE': 1
    'ServiceBusTopic': sb_topic_name
    'ServiceBusSubscription': sb_subscr_name
    'ServiceBusConnectionString': '@Microsoft.KeyVault(VaultName=${kv_name};SecretName=${kvsecret_name_sbcs})'
    'SqlConnectionString': '@Microsoft.KeyVault(VaultName=${kv_name};SecretName=${kvsecret_name_sqlcs})'
  }
}

resource FuncStorage 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: func_storage_name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    isHnsEnabled: true
  }
}

resource FuncInsight 'microsoft.insights/components@2020-02-02-preview' = {
  name: func_insight_name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output FuncAppPrincipalId string = FuncApp.identity.principalId
