[[_TOC_]]

---
# Preparations
## Azure Service Connection
- Azure DevOps -> Project settings -> Service connections -> New service connection
  - Azure Resource Manager -> Service Principal (automatic)
    - Scope level: Subscription
    - Select Subscription
    - Resource Group can be empty (Select a resource group if you want to scope)
    - Define service connection name
    - Save
- Azure Portal -> Azure Active Directory -> App registrations -> Find the Azure Service Connection app
  - Overview -> Managed application in local directory (Redirect to Enterprise Application section)
    - Keep name and Object ID for later usage

## Azure Active Directory App registration
- Azure Portal -> Azure Active Directory -> App registrations -> New registration
  - Name: Your client app name
  - Register
  - Azure Portal -> Azure Active Directory -> App registrations -> Select your client app
    - Certificates & secrets -> New client secret
      - Keep the secret for later usage
    - Overview
      - Keep Application ID for later usage
- Azure Portal -> Azure Active Directory -> App registrations -> New registration
  - Name: Your backend app name
  - Register
  - Azure Portal -> Azure Active Directory -> App registrations -> Select your backend app
    - Expose an API -> Application ID URI -> Set
    - Overview
      - Keep Application ID for later usage

## Personal access token for self-hosted agent

- Azure DevOps -> User settings -> Personal access tokens -> + New Token
  - Name: Define a token display name
  - Expiration: Define expiration
  - Scopes: Check Agent Pools Read&Manage
  - Create
  - Keep the token for later usage

## Azure Pipeline Library Variable Group

- Azure DevOps -> Pipelines -> Library -> + Variable group
  - Variable group name: `vg-sample`

| Variable name     | Description |
| ----------------- | ---------- |
| AZURE_SVC_NAME    | Azure Service Connection name |
| AAD_NAME_SVC      | Azure Service Connection Azure Active Directory name |
| AAD_OBJECTID_SVC  | Azure Servcie Connection Azure Active Directory object ID |
| AAD_APPID_CLIENT  | Application ID for client app in Azure Active Directory |
| AAD_APPID_BACKEND | Application ID for backend app in Azure Active Directory |
| AAD_TENANTID      | Tenant ID of Azure Active Directory |

## variables.yml

Go to `pipelines/templates/variables.yml`, and you only need to define three variables. Other variables do not need to be changed.

| Variable name      | Description |
| ------------------ |------------ |
| BASE_NAME          | Azure resource base name. ex. rg-{BASE_NAME}-{ENVIRONMENT_SYMBOL} |
| ENVIRONMENT_SYMBOL | Azure resource environment symbol. ex. rg-{BASE_NAME}-{ENVIRONMENT_SYMBOL} |
| LOCATION           | Azure resource location |

## Azure Pipeline variables

- **pipeline-base**
  - Azure DevOps -> Pipelines -> New pipeline
    - Select your repository type. ex. Azure Repos Git
    - Select your repository name. ex. apim-vnet
    - Select "Existing Azure Pipelines YAML file".
    - Path: `/pipelines/templates/pipeline-base.yml` and "Continue".
    - Variables -> New variable
      - Enter values accordingly
      - Check "Keep this value secret"
  
| Variable name     | Description |
| ----------------- |------------ |
| SQL_PASS          | You define SQL Server admin password |
| AAD_SECRET_CLIENT | The client app secret of Azure Active Directory you generated in the previous step  |

- **pipeline-vnet1**
  - Azure DevOps -> Pipelines -> New pipeline
    - Select your repository type. ex. Azure Repos Git
    - Select your repository name. ex. apim-vnet
    - Select "Existing Azure Pipelines YAML file".
    - Path: `/pipelines/templates/pipeline-vnet1.yml` and "Continue".
    - Variables -> New variable
      - Enter values accordingly
      - Check "Keep this value secret"
  
| Variable name     | Description |
| ----------------- |------------ |
| SQL_PASS          | You define SQL Server admin password |
| AAD_SECRET_CLIENT | The client app secret of Azure Active Directory you generated in the previous step  |
| AZP_TOKEN         | The personal token for a self-hosted agent you generated in the previous step  |

- **pipeline-vnet2**
  - Azure DevOps -> Pipelines -> New pipeline
    - Select your repository type. ex. Azure Repos Git
    - Select your repository name. ex. apim-vnet
    - Select "Existing Azure Pipelines YAML file".
    - Path: `/pipelines/templates/pipeline-vnet2.yml` and "Continue".

# Pipeline execution

- Azure DevOps -> Pipelines

**base**
- Run `pipeline-base.yml`

**vnet**
- Run `pipeline-vnet1.yml` and then `pipeline-vnet2.yml`