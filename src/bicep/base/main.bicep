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

param sql_username string
param sb_topic_name string
param sb_subscr_name string

param location string = resourceGroup().location

var tenant_id = tenant().tenantId
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

module SqlDatabaseModule './modules/SqlDatabase.bicep' = {
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

module ServiceBusModule './modules/ServiceBus.bicep' = {
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
  }
}

module KeyVaultModule './modules/KeyVault.bicep' = {
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
    sqlserver_name:sqlserver_name
    sqldb_name:sqldb_name
    sql_username:sql_username
    sql_pass:sql_pass
    AppServiceMidPrincipalId:AppServiceModule.outputs.AppServiceMidPrincipalId
    FuncAppPrincipalId:FuncAppModule.outputs.FuncAppPrincipalId
    ServiceBusId:ServiceBusModule.outputs.ServiceBusId
    ServiceBusApiVersion:ServiceBusModule.outputs.ServiceBusApiVersion
  }
}
