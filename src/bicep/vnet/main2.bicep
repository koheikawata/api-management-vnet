param base_name string
param environment_symbol string

param aad_name_svc string
param aad_objectid_svc string

@secure()
param sql_pass string

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
var managed_id_name = 'mid-${base_name}-${environment_symbol}'
var appsrv_name = 'app-${base_name}-${environment_symbol}'
var func_name = 'func-${base_name}-${environment_symbol}'
var kv_name = 'kv-${base_name}-${environment_symbol}'
var sqlserver_name = 'sql-${base_name}-${environment_symbol}'
var sqldb_name = 'sqldb-${base_name}-${environment_symbol}'
var sb_name = 'sb-${base_name}-${environment_symbol}'
var vnet_name_1 = 'vnet-1-${base_name}-${environment_symbol}'
var vnet_name_2 = 'vnet-2-${base_name}-${environment_symbol}'
var vnet_name_3 = 'vnet-3-${base_name}-${environment_symbol}'
var pdns_name_kv = 'privatelink.vaultcore.azure.net'
var pdns_name_sql = 'privatelink${environment().suffixes.sqlServerHostname}'
var pdns_name_sb = 'privatelink.servicebus.windows.net'
var pdns_name_app = 'privatelink.azurewebsites.net'
var pe_name_kv = 'pe-kv-${base_name}-${environment_symbol}'
var pe_name_sql = 'pe-sql-${base_name}-${environment_symbol}'
var pe_name_sb = 'pe-sb-${base_name}-${environment_symbol}'
var pe_name_ase = 'pe-app-${base_name}-${environment_symbol}'
var pe_name_func = 'pe-func-${base_name}-${environment_symbol}'

resource existingKv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: kv_name
}

resource existingSql 'Microsoft.Sql/servers@2021-02-01-preview' existing = {
  name: sqlserver_name
}

resource existingSb 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' existing = {
  name: sb_name
}

resource existingVnet1 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  name: vnet_name_1
}

resource existingVnet2 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  name: vnet_name_2
}

resource existingVnet3 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  name: vnet_name_3
}

resource existingMid 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: managed_id_name
}

resource existingAppService 'Microsoft.Web/sites@2021-02-01' existing = {
  name: appsrv_name
}

resource existingFunc 'Microsoft.Web/sites@2021-02-01' existing = {
  name: func_name
}

module PrivateEndpointModule './modules/PrivateEndpoint.bicep' = {
  name: 'PrivateEndpointDeploy'
  params: {
    location:location
    pe_name_kv:pe_name_kv
    pe_name_sql:pe_name_sql
    pe_name_sb:pe_name_sb
    pe_name_ase:pe_name_ase
    pe_name_func:pe_name_func
    KeyVaultId:existingKv.id
    SqlServerId:existingSql.id
    ServiceBusId:existingSb.id
    AppServiceId:existingAppService.id
    FuncId:existingFunc.id
    VirtualNetwork2SubnetIdKv:existingVnet2.properties.subnets[3].id
    VirtualNetwork2SubnetIdSql:existingVnet2.properties.subnets[2].id
    VirtualNetwork3SubnetIdSb:existingVnet3.properties.subnets[0].id
    VirtualNetwork2SubnetIdAsePe:existingVnet2.properties.subnets[1].id
    VirtualNetwork2SubnetIdFuncPe:existingVnet2.properties.subnets[5].id
  }
}

module PrivateDnsModule './modules/PrivateDns2.bicep' = {
  name: 'PrivateDnsDeploy'
  params: {
    pdns_name_kv:pdns_name_kv
    pdns_name_sql:pdns_name_sql
    pdns_name_sb:pdns_name_sb
    pdns_name_app:pdns_name_app
    KeyVaultName:existingKv.name
    SqlServerName:existingSql.name
    ServiceBusName:existingSb.name
    AppServiceName:existingAppService.name
    FuncName:existingFunc.name
    VirtualNetwork1Id:existingVnet1.id
    VirtualNetwork2Id:existingVnet2.id
    VirtualNetwork3Id:existingVnet3.id
    PrivateEndpointKvIpAddress:PrivateEndpointModule.outputs.PrivateEndpointKvIpAddress
    PrivateEndpointSqlIpAddress:PrivateEndpointModule.outputs.PrivateEndpointSqlIpAddress
    PrivateEndpointSbIpAddress:PrivateEndpointModule.outputs.PrivateEndpointSbIpAddress
    PrivateEndpointAseIpAddress:PrivateEndpointModule.outputs.PrivateEndpointAseIpAddress
    PrivateEndpointFuncIpAddress:PrivateEndpointModule.outputs.PrivateEndpointFuncIpAddress
  }
}

module KeyVaultModule './modules/KeyVault2.bicep' = {
  name: 'KeyVaultDeploy'
  params: {
    location:location
    tenant_id:tenant_id
    aad_objectid_svc:aad_objectid_svc
    kv_name:kv_name
    AppGatewayMidPrincipalId:existingMid.properties.principalId
    AppServiceMidPrincipalId:existingAppService.identity.principalId
    FuncAppPrincipalId:existingFunc.identity.principalId
    VirtualNetwork1SubnetIdAgw:existingVnet1.properties.subnets[0].id
  }
  dependsOn: [
    PrivateDnsModule
  ]
}

module SqlDatabaseModule './modules/SqlDatabase2.bicep' = {
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

module ServiceBusModule './modules/ServiceBus2.bicep' = {
  name: 'ServiceBusDeploy'
  params: {
    location:location
    sb_name:sb_name
    sb_topic_name:sb_topic_name
    sb_subscr_name:sb_subscr_name
  }
}
