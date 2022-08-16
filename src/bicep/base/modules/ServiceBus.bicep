param location string
param sb_name string
param sb_topic_name string
param sb_subscr_name string

resource ServiceBus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: sb_name
  location: location
  sku: {
    name: 'Premium'
  }
  resource ServicebusAuthRulesRoot 'AuthorizationRules' = {
    name: 'RootManageSharedAccessKey'
    properties: {
      rights: [
        'Listen'
        'Send'
        'Manage'
      ]
    }
  }
  resource ServicebusTopic 'topics' = {
    name: sb_topic_name
    resource ServicebusSubscription 'Subscriptions' = {
      name: sb_subscr_name
    }
  }
}

output ServiceBusId string = ServiceBus.id
output ServiceBusApiVersion string = ServiceBus.apiVersion
