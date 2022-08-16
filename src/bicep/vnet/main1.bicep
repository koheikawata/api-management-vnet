param base_name string
param environment_symbol string
param kvcert_name_agw string
param kvsecret_name_sqlpass string
param kvsecret_name_sqlcs string
param kvsecret_name_sbcs string
param kvsecret_name_aadclient string
param kvsecret_name_azptoken string
param api_name string

param aad_name_svc string
param aad_objectid_svc string
param aad_appid string
param aad_tenantid string

@secure()
param sql_pass string
@secure()
param aad_secret_client string
@secure()
param azp_token string

param vnet_ipprefix_1 string
param vnet_ipprefix_2 string
param vnet_ipprefix_3 string
param snet_prefix_1_agw string
param snet_prefix_1_apim string
param snet_prefix_2_ase_vi string
param snet_prefix_2_ase_pe string
param snet_prefix_2_sql string
param snet_prefix_2_kv string
param snet_prefix_2_func_vi string
param snet_prefix_2_func_pe string
param snet_prefix_2_shagent string
param snet_prefix_3_sb string
param sql_username string
param sb_topic_name string
param sb_subscr_name string

param location string = resourceGroup().location

var tenant_id = tenant().tenantId
var pip_name_agw = 'pip-agw-${base_name}-${environment_symbol}'
var waf_name = 'waf-${base_name}-${environment_symbol}'
var managed_id_name = 'mid-${base_name}-${environment_symbol}'
var agw_name = 'agw-${base_name}-${environment_symbol}'
var agw_kv_secret_id = 'https://${kv_name}${environment().suffixes.keyvaultDns}/secrets/${kvcert_name_agw}'
var appsrvplan_name = 'aplan-${base_name}-${environment_symbol}'
var appsrv_name = 'app-${base_name}-${environment_symbol}'
var apim_name = 'apim-${base_name}-${environment_symbol}'
var apim_service_url = 'https://${appsrv_name}.azurewebsites.net'
var funcplan_name = 'fplan-${base_name}-${environment_symbol}'
var func_name = 'func-${base_name}-${environment_symbol}'
var func_storage_name = 'stfunc${base_name}${environment_symbol}'
var func_insight_name = 'appi-${base_name}-${environment_symbol}'
var sqlserver_name = 'sql-${base_name}-${environment_symbol}'
var sqldb_name = 'sqldb-${base_name}-${environment_symbol}'
var kv_name = 'kv-${base_name}-${environment_symbol}'
var sb_name = 'sb-${base_name}-${environment_symbol}'
var vnet_name_1 = 'vnet-1-${base_name}-${environment_symbol}'
var snet_name_1_agw = 'snet-1-agw'
var snet_name_1_apim = 'snet-1-apim'
var vnet_name_2 = 'vnet-2-${base_name}-${environment_symbol}'
var snet_name_2_ase_vi = 'snet-2-ase-vi'
var snet_name_2_ase_pe = 'snet-2-ase-pe'
var snet_name_2_sql = 'snet-2-sql'
var snet_name_2_kv = 'snet-2-kv'
var snet_name_2_func_vi = 'snet-2-func-vi'
var snet_name_2_func_pe = 'snet-2-func-pe'
var snet_name_2_shagent = 'snet-2-shagent'
var vnet_name_3 = 'vnet-3-${base_name}-${environment_symbol}'
var snet_name_3_sb = 'snet-3-sb'
var vnetpeer_name_23 = 'peer-23'
var vnetpeer_name_32 = 'peer-32'
var vnetpeer_name_12 = 'peer-12'
var vnetpeer_name_21 = 'peer-21'
var nsg_name_1_agw = 'nsg-1-agw-${base_name}-${environment_symbol}'
var nsg_name_1_apim = 'nsg-1-apim-${base_name}-${environment_symbol}'
var nsg_name_2_ase_vi = 'nsg-2-asevi-${base_name}-${environment_symbol}'
var nsg_name_2_ase_pe = 'nsg-2-asepe-${base_name}-${environment_symbol}'
var nsg_name_2_sql = 'nsg-2-sql-${base_name}-${environment_symbol}'
var nsg_name_2_kv = 'nsg-2-kv-${base_name}-${environment_symbol}'
var nsg_name_2_func_vi = 'nsg-2-funcvi-${base_name}-${environment_symbol}'
var nsg_name_2_func_pe = 'nsg-2-funcpe-${base_name}-${environment_symbol}'
var nsg_name_2_shagent = 'nsg-2-sha-${base_name}-${environment_symbol}'
var nsg_name_3_sb = 'nsg-3-sb-${base_name}-${environment_symbol}'
var pdns_name_apim = 'azure-api.net'
var acr_name = 'cr${base_name}${environment_symbol}'

module NsgModule './modules/NetworkSecurityGroup.bicep' = {
  name: 'NsgDeploy'
  params: {
    location:location
    nsg_name_1_agw:nsg_name_1_agw
    nsg_name_1_apim:nsg_name_1_apim
    nsg_name_2_ase_vi:nsg_name_2_ase_vi
    nsg_name_2_ase_pe:nsg_name_2_ase_pe
    nsg_name_2_sql:nsg_name_2_sql
    nsg_name_2_kv:nsg_name_2_kv
    nsg_name_2_func_vi:nsg_name_2_func_vi
    nsg_name_2_func_pe:nsg_name_2_func_pe
    nsg_name_2_shagent:nsg_name_2_shagent
    nsg_name_3_sb:nsg_name_3_sb
    snet_prefix_1_agw:snet_prefix_1_agw
  }
}

module VnetModule './modules/VirtualNetwork.bicep' = {
  name: 'VnetDeploy'
  params: {
    location:location
    vnet_name_1:vnet_name_1
    vnet_name_2:vnet_name_2
    vnet_name_3:vnet_name_3
    snet_name_1_agw:snet_name_1_agw
    snet_name_1_apim:snet_name_1_apim
    snet_name_2_ase_vi:snet_name_2_ase_vi
    snet_name_2_ase_pe:snet_name_2_ase_pe
    snet_name_2_sql:snet_name_2_sql
    snet_name_2_kv:snet_name_2_kv
    snet_name_2_func_vi:snet_name_2_func_vi
    snet_name_2_func_pe:snet_name_2_func_pe
    snet_name_2_shagent:snet_name_2_shagent
    snet_name_3_sb:snet_name_3_sb
    vnet_ipprefix_1:vnet_ipprefix_1
    vnet_ipprefix_2:vnet_ipprefix_2
    vnet_ipprefix_3:vnet_ipprefix_3
    snet_prefix_1_agw:snet_prefix_1_agw
    snet_prefix_1_apim:snet_prefix_1_apim
    snet_prefix_2_ase_vi:snet_prefix_2_ase_vi
    snet_prefix_2_ase_pe:snet_prefix_2_ase_pe
    snet_prefix_2_sql:snet_prefix_2_sql
    snet_prefix_2_kv:snet_prefix_2_kv
    snet_prefix_2_func_vi:snet_prefix_2_func_vi
    snet_prefix_2_func_pe:snet_prefix_2_func_pe
    snet_prefix_2_shagent:snet_prefix_2_shagent
    snet_prefix_3_sb:snet_prefix_3_sb
    vnetpeer_name_23:vnetpeer_name_23
    vnetpeer_name_32:vnetpeer_name_32
    vnetpeer_name_12:vnetpeer_name_12
    vnetpeer_name_21:vnetpeer_name_21
    Nsg1AgwId:NsgModule.outputs.Nsg1AgwId
    Nsg1ApimId:NsgModule.outputs.Nsg1ApimId
    Nsg2AseViId:NsgModule.outputs.Nsg2AseViId
    Nsg2AsePeId:NsgModule.outputs.Nsg2AsePeId
    Nsg2SqlId:NsgModule.outputs.Nsg2SqlId
    Nsg2KvId:NsgModule.outputs.Nsg2KvId
    Nsg2FuncViId:NsgModule.outputs.Nsg2FuncViId
    Nsg2FuncPeId:NsgModule.outputs.Nsg2FuncPeId
    Nsg2ShagentId:NsgModule.outputs.Nsg2ShagentId
    Nsg3SbId:NsgModule.outputs.Nsg3SbId
  }
}

module SqlDatabaseModule './modules/SqlDatabase1.bicep' = {
  name: 'SqlDatabaseDeploy'
  params: {
    location:location
    tenant_id:tenant_id
    aad_name_svc:aad_name_svc
    aad_objectid_svc:aad_objectid_svc
    sqlserver_name:sqlserver_name
    sqldb_name:sqldb_name
    sql_username:sql_username
    sql_pass:sql_pass
  }
}

module ServiceBusModule './modules/ServiceBus1.bicep' = {
  name: 'ServiceBusDeploy'
  params: {
    location:location
    sb_name:sb_name
    sb_topic_name:sb_topic_name
    sb_subscr_name:sb_subscr_name
  }
}

module ApiManagementModule './modules/ApiManagement.bicep' = {
  name: 'ApiManagementDeploy'
  params: {
    apim_name:apim_name
    location:location
    api_name:api_name
    apim_service_url:apim_service_url
    VirtualNetwork1SubnetIdApim:VnetModule.outputs.VirtualNetwork1SubnetIdApim
  }
}

module AppServiceModule './modules/AppService.bicep' = {
  name: 'AppServiceDeploy'
  params: {
    location:location
    appsrvplan_name:appsrvplan_name
    appsrv_name:appsrv_name
    aad_appid:aad_appid
    aad_tenantid:aad_tenantid
    kv_name:kv_name
    kvsecret_name_sqlcs:kvsecret_name_sqlcs
    kvsecret_name_sbcs:kvsecret_name_sbcs
    sb_topic_name:sb_topic_name
    VirtualNetwork2SubnetIdAseVi:VnetModule.outputs.VirtualNetwork2SubnetIdAseVi
  }
}

module FuncAppModule './modules/FunctionApp.bicep' = {
  name: 'FuncAppDeploy'
  params: {
    location:location
    funcplan_name:funcplan_name
    func_name:func_name
    func_storage_name:func_storage_name
    func_insight_name:func_insight_name
    sb_topic_name:sb_topic_name
    sb_subscr_name:sb_subscr_name
    kv_name:kv_name
    kvsecret_name_sbcs:kvsecret_name_sbcs
    kvsecret_name_sqlcs:kvsecret_name_sqlcs
    VirtualNetwork2SubnetIdFuncVi:VnetModule.outputs.VirtualNetwork2SubnetIdFuncVi
  }
}

resource ManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managed_id_name
  location: location
}

module KeyVaultModule './modules/KeyVault1.bicep' = {
  name: 'KeyVaultDeploy'
  params: {
    location:location
    tenant_id:tenant_id
    aad_objectid_svc:aad_objectid_svc
    aad_secret_client:aad_secret_client
    kv_name:kv_name
    kvsecret_name_sqlpass:kvsecret_name_sqlpass
    kvsecret_name_sqlcs:kvsecret_name_sqlcs
    kvsecret_name_sbcs:kvsecret_name_sbcs
    kvsecret_name_aadclient:kvsecret_name_aadclient
    kvsecret_name_azptoken:kvsecret_name_azptoken
    sqlserver_name:sqlserver_name
    sqldb_name:sqldb_name
    sql_username:sql_username
    sql_pass:sql_pass
    azp_token:azp_token
    AppGatewayMidPrincipalId:ManagedIdentity.properties.principalId
    AppServiceMidPrincipalId:AppServiceModule.outputs.AppServiceMidPrincipalId
    FuncAppPrincipalId:FuncAppModule.outputs.FuncAppPrincipalId
    ServiceBusId:ServiceBusModule.outputs.ServiceBusId
    ServiceBusApiVersion:ServiceBusModule.outputs.ServiceBusApiVersion
  }
}

module AppGatewayModule './modules/ApplicationGateway.bicep' = {
  name: 'AppGatewayDeploy'
  params: {
    location:location
    public_ip_address_name:pip_name_agw
    appsrv_name:appsrv_name
    waf_name:waf_name
    agw_name:agw_name
    apim_name:apim_name
    agw_kv_secret_id:agw_kv_secret_id
    ManagedIdentityId:ManagedIdentity.id
    VirtualNetwork1SubnetIdAgw:VnetModule.outputs.VirtualNetwork1SubnetIdAgw
  }
  dependsOn: [
    KeyVaultModule
  ]
}

module PrivateDns './modules/PrivateDns1.bicep' = {
  name: 'PrivateDnsDeploy'
  params: {
    pdns_name_apim:pdns_name_apim
    ApiManagementName:ApiManagementModule.outputs.ApiManagementName
    ApiManagementPrivateIPAddress:ApiManagementModule.outputs.ApiManagementPrivateIPAddress
    VirtualNetwork1Id:VnetModule.outputs.VirtualNetwork1Id
  }
}

resource ContainerRegistry 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: acr_name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}
