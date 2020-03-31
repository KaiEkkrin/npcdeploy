# Notes on deploying npc to Azure

## Helpful Links

[Create an App Service app with deployment from GitHub](https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-deploy-github?toc=/cli/azure/toc.json)

[Create an App Service app with continuous deployment from GitHub](https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-continuous-deployment-github)

## Manual publishing steps

- Have an Azure Web App made already.  (I used the `deploy_once.sh` script, which didn't do what I hoped, but did make one.
- Make a build:

```powershell
dotnet publish -c Release
```

- In the Azure website (the Deployment Center for the web app), select Manual Deployment -> OneDrive
- Copy the contents of the `npcblas2\bin\Release\netcoreapp3.1\publish` folder to a folder in OneDrive within `Apps\Azure Web Apps` that matches the name of the web app
- Specify the folder in the Deployment Center wizard

## Authentication and authorization

We don't implement this ourselves but instead enable [Azure App Service Authentication](https://docs.microsoft.com/en-us/azure/app-service/overview-authentication-authorization).  This forces the user to log in before reaching us (that's okay) and populates `ClaimsPrincipal.Current` for us.  To support local debug builds as well we need to be okay with that thing being null, but in debug only.

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

## Data Store

For localhost testing, install the [Azure Cosmos Emulator](https://docs.microsoft.com/en-us/azure/cosmos-db/local-emulator).

Read the [Cosmos DB emulator page](https://localhost:8081/_explorer/index.html) for the values for the parameters to configure.  You need to create a new database but *not* a new container, Entity Framework Core will do that for you.

```powershell
dotnet user-secrets set Cosmos:Uri "https://localhost:8081"
dotnet user-secrets set Cosmos:Key <primary key>
dotnet user-secrets set Cosmos:DatabaseName <database name>
```

Azure app service configuration is done as above.
