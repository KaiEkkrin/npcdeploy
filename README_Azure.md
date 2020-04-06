# Notes on deploying npc to Azure

## Helpful Links

[Create an App Service app with deployment from GitHub](https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-deploy-github?toc=/cli/azure/toc.json)

[Create an App Service app with continuous deployment from GitHub](https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-continuous-deployment-github)

## Creating the application template in the first place

We use Blazor Server with individual authentication:

```powershell
dotnet new blazorserver -au Individual
```

## Manual publishing steps

- Have an Azure Web App made already.  (I used the `deploy_once.sh` script, which didn't do what I hoped, but did make one.
- Make a build:

```powershell
dotnet publish -c Release
```

- In the Azure website (the Deployment Center for the web app), select Manual Deployment -> OneDrive
- Copy the contents of the `npcblas2\bin\Release\netcoreapp3.1\publish` folder to a folder in OneDrive within `Apps\Azure Web Apps` that matches the name of the web app
- Specify the folder in the Deployment Center wizard

## Google Authentication

We followed [these instructions](https://ankitsharmablogs.com/google-authentication-and-authorization-in-server-side-blazor-app/).  We create separate OAuth client IDs for the developer build (localhost) and the deployed one(s).  For example, for the developer build:

- Authorised JavaScript origins: `https://localhost:5001`
- Redirect URI: `https://localhost:5001/signin-google`

To add secrets locally for testing,

```powershell
dotnet user-secrets set Authentication:Google:ClientId <client id> --project npcblas2\npcblas2.csproj
dotnet user-secrets set Authentication:Google:ClientSecret <client secret> --project npcblas2\npcblas2.csproj
```

Azure app service configuration is done using Configuration -> Application settings, with the same names and values.

Here's an [ASP.NET Core Identity with Cosmos DB](https://alejandroruizvarela.blogspot.com/2018/11/aspnet-core-identity-with-cosmos-db.html) article.

To alter the Identity-related pages, we scaffolded them using [these instructions.](https://docs.microsoft.com/en-us/aspnet/core/security/authentication/scaffold-identity?view=aspnetcore-3.1&tabs=netcore-cli)

[These suggestions](https://korzh.com/blogs/dotnet-stories/add-extra-user-claims-aspnet-core-webapp) for adding claims to the ClaimsPrincipals have been helpful as a guide for customising Identity.

To help find existing users in the Azure Cosmos DB, use a query like this:

```sql
SELECT * FROM c WHERE STARTSWITH(c.id, "IdentityUser")
```

or after the ApplicationUser change,

```sql
SELECT * FROM c WHERE STARTSWITH(c.id, "IdentityUser")
```

To specify which user should be granted IsAdmin on startup if no user has admin yet:

```powershell
dotnet user-secrets set Authentication:AdminUser <user email>
```

## Data Store

For localhost testing, install the [Azure Cosmos Emulator](https://docs.microsoft.com/en-us/azure/cosmos-db/local-emulator).

Read the [Cosmos DB emulator page](https://localhost:8081/_explorer/index.html) for the values for the parameters to configure.  You need to create a new database but *not* a new container, Entity Framework Core will do that for you.

```powershell
dotnet user-secrets set Cosmos:Uri "https://localhost:8081"
dotnet user-secrets set Cosmos:Key <primary key>
dotnet user-secrets set Cosmos:DatabaseName <database name>
```

Azure app service configuration is done as above.

[How to do relations with EF Core and Cosmos DB.](https://csharp.christiannagel.com/2019/04/24/cosmosdbwithefcore/)
