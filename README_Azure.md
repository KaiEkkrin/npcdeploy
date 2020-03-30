# Notes on deploying npc to Azure

## Helpful Links

[Create an App Service app with deployment from GitHub](https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-deploy-github?toc=/cli/azure/toc.json)

[Create an App Service app with continuous deployment from GitHub](https://docs.microsoft.com/en-us/azure/app-service/scripts/cli-continuous-deployment-github)

## Manual publishing steps

- Have an Azure Web App made already.  (I used the `deploy_once.sh` script, which didn't do what I hoped, but did make one.
- Make a build:

```powershell
cd npcsrv\src
dotnet publish -c Release
```

- In the Azure website (the Deployment Center for the web app), select Manual Deployment -> OneDrive
- Copy the contents of the `npcsrv\src\npcblas\bin\Release\netcoreapp3.1\publish` folder to a folder in OneDrive within `Apps\Azure Web Apps` that matches the name of the web app
- Specify the folder in the Deployment Center wizard
