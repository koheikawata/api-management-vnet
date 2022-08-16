var agw_gateway_ip_config_name = 'appGatewayIpConfig'
var agw_ssl_certificate_name = 'appGatewaySslCert'
var agw_frontend_ip_config_name = 'appGatewayFrontendIpConfig'
var agw_frontend_ports_name = 'appGatewayFrontendPort'
var agw_backend_address_pools_name = 'appGatewayBackendAddressPool'
var agw_http_setting_name = 'appGatewayHttpSetting'
var agw_listener_name = 'appGatewayListener'
var agw_routing_rules_name = 'appGatewayRoutingRule'
var agw_probe_name= 'appGateWayProbe'

param location string
param public_ip_address_name string
param appsrv_name string
param waf_name string
param agw_name string
param apim_name string
param agw_kv_secret_id string
param ManagedIdentityId string
param VirtualNetwork1SubnetIdAgw string

resource PublicIpAddress 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: public_ip_address_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: appsrv_name
    }
  }
}

resource AgwFirewallPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2021-03-01' = {
  name: waf_name
  location: location
  properties: {
    policySettings: {
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
      state: 'Enabled'
      mode: 'Prevention'
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.1'
        }
      ]
    }
  }
}

resource AppGateway 'Microsoft.Network/applicationGateways@2021-03-01' = {
  name: agw_name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${ManagedIdentityId}': {}
    }
  }
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    autoscaleConfiguration: {
      minCapacity: 2
      maxCapacity: 5
    }
    enableHttp2: true
    forceFirewallPolicyAssociation: true
    firewallPolicy: {
      id: AgwFirewallPolicy.id
    }
    gatewayIPConfigurations: [
      {
        name: agw_gateway_ip_config_name
        properties: {
          subnet: {
            id: VirtualNetwork1SubnetIdAgw
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: agw_ssl_certificate_name
        properties: {
          keyVaultSecretId: agw_kv_secret_id
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: agw_frontend_ip_config_name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: PublicIpAddress.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: agw_frontend_ports_name
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: agw_backend_address_pools_name
        properties: {
          backendAddresses: [
            {
              fqdn: '${apim_name}.azure-api.net'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: agw_http_setting_name
        properties: {
          port:443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          requestTimeout: 20
          probe: {
            id: resourceId('Microsoft.Network/applicationGateways/probes', agw_name, agw_probe_name)
          }
        }
      }
    ]
    httpListeners: [
      {
        name: agw_listener_name
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', agw_name, agw_frontend_ip_config_name)
          }
          frontendPort:{
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', agw_name, agw_frontend_ports_name)
          }
          protocol: 'Https'
          sslCertificate: {
            id: resourceId('Microsoft.Network/applicationGateways/sslCertificates', agw_name, agw_ssl_certificate_name)
          }
          requireServerNameIndication: false
        }
      }
    ]
    requestRoutingRules: [
      {
        name: agw_routing_rules_name
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', agw_name, agw_listener_name)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', agw_name, agw_backend_address_pools_name)
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', agw_name, agw_http_setting_name)
          }
        }
      }
    ]
    probes: [
      {
        name: agw_probe_name
        properties: {
          protocol: 'Https'
          path: '/status-0123456789abcdef'
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: true
        }
      }
    ]
  }
}
