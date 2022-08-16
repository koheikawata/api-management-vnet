using Azure.Core;
using Azure.Identity;
using Microsoft.Data.SqlClient;
using System.Threading.Tasks;

namespace ServicebusListener.Authentication
{
    internal class CustomAzureSQLAuthProvider : SqlAuthenticationProvider
    {
        private readonly TokenCredential credential = new DefaultAzureCredential();

        public override async Task<SqlAuthenticationToken> AcquireTokenAsync(SqlAuthenticationParameters parameters)
        {
            TokenRequestContext tokenRequestContext = new(new[] { "https://database.windows.net//.default" });
            AccessToken tokenResult = await this.credential.GetTokenAsync(tokenRequestContext, default);
            return new SqlAuthenticationToken(tokenResult.Token, tokenResult.ExpiresOn);
        }

        public override bool IsSupported(SqlAuthenticationMethod authenticationMethod)
            => authenticationMethod.Equals(SqlAuthenticationMethod.ActiveDirectoryDefault);
    }
}
