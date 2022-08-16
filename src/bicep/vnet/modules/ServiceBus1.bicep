param location string
param sb_name string
param sb_topic_name string
param sb_subscr_name string

resource ServiceBus 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: sb_name
  location: location
  sku: {
    name: 'Premium'
  }
}

resource ServicebusAuthRulesRoot 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2022-01-01-preview' = {
  name: '${ServiceBus.name}/RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Send'
      'Manage'
    ]
  }
}

resource ServicebusTopic 'Microsoft.ServiceBus/namespaces/topics@2022-01-01-preview' = {
  name: '${ServiceBus.name}/${sb_topic_name}'
  resource ServicebusSubscription 'Subscriptions' = {
    name: sb_subscr_name
  }
}

output ServiceBusName string = ServiceBus.name
output ServiceBusId string = ServiceBus.id
output ServiceBusApiVersion string = ServiceBus.apiVersion
