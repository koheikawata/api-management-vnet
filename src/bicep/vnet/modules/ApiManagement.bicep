param apim_name string
param location string
param api_name string
param apim_service_url string
param VirtualNetwork1SubnetIdApim string

resource ApiManagement 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: apim_name
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    notificationSenderEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherEmail: 'dummy@email.com'
    publisherName: 'dummy'
    virtualNetworkConfiguration: {
      subnetResourceId: VirtualNetwork1SubnetIdApim
    }
    virtualNetworkType: 'Internal'
  }
}

resource ApiManagementApi 'Microsoft.ApiManagement/service/apis@2021-08-01' = {
  name: '${ApiManagement.name}/${api_name}'
  properties: {
    displayName: api_name
    subscriptionRequired: false
    serviceUrl: apim_service_url
    protocols: [
      'https'
    ]
    path: '/${api_name}'
  }
}

output ApiManagementName string = ApiManagement.name
output ApiManagementPrivateIPAddress string = ApiManagement.properties.privateIPAddresses[0]
