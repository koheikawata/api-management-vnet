param base_name string
param environment_symbol string
param shagent_repository_name string
param image_tag string
@secure()
param azp_token string

param shagent_ado_org_name string
param shagent_name string

param location string = resourceGroup().location

var acr_name = 'cr${base_name}${environment_symbol}'
var vnet_name_common = 'vnet-2-${base_name}-${environment_symbol}'
var aci_name = 'aci-l-${base_name}-${environment_symbol}'
var image_name = '${acr_name}.azurecr.io/${shagent_repository_name}:${image_tag}'

resource existingAcr 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: acr_name
}

resource existingVnet 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  name: vnet_name_common
}

resource ContainerGroup 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
  name: aci_name
  location: location
  properties: {
    sku: 'Standard'
    osType: 'Linux'
    restartPolicy: 'Always'
    subnetIds: [
      {
        id: existingVnet.properties.subnets[6].id
      }
    ]
    imageRegistryCredentials: [
      {
        server: existingAcr.properties.loginServer
        username: existingAcr.listCredentials().username
        password: existingAcr.listCredentials().passwords[0].value
      }
    ]
    containers: [
      {
        name: aci_name
        properties: {
          image: image_name
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
          environmentVariables: [
            {
              name: 'AZP_URL'
              value: 'https://dev.azure.com/${shagent_ado_org_name}'
            }
            {
              name: 'AZP_TOKEN'
              value: azp_token
            }
            {
              name: 'AZP_AGENT_NAME'
              value: '${shagent_name}-${base_name}-${environment_symbol}'
            }
          ]
          resources: {
            requests: {
              memoryInGB: 4
              cpu: 1
            }
          }
        }
      }
    ]
  }
}
