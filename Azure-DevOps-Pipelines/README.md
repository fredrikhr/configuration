# Azure DevOps Pipelines

This repository contains `azure-pipelines.yml` examples for building TH-NETII
Respositories.

The corresponding YAML file should be copied into the root of the target
repository.

## .NET Core CI Build Pipeline

The `azure-pipelines.dotnetcore.*.yml` files define the
jobs to

1. Restore
1. Build
1. Test
1. Publish

.NET Core projects unsing the Azure DevOps built-in .NET Core CLI task.

Execute the following commands to download the files into your repository root or, even-better, into a `.azure-pipelines` directory:

### Download command (execute in `.azure-pipelines` directory)

``` sh
curl -LORJ "https://github.com/couven92/configuration/raw/master/Azure-DevOps-Pipelines/azure-pipelines.dotnetcore.build.yml" -LORJ "https://github.com/couven92/configuration/raw/master/Azure-DevOps-Pipelines/azure-pipelines.dotnetcore.buildSteps.yml" -LORJ "https://github.com/couven92/configuration/raw/master/Azure-DevOps-Pipelines/azure-pipelines.dotnetcore.test.yml" -LORJ "https://github.com/couven92/configuration/raw/master/Azure-DevOps-Pipelines/azure-pipelines.dotnetcore.testSteps.yml" -LORJ "https://github.com/couven92/configuration/raw/master/Azure-DevOps-Pipelines/download-azuredevops-msbuild-logger.ps1" -LORJ "https://github.com/couven92/configuration/raw/master/Azure-DevOps-Pipelines/download-azuredevops-msbuild-logger.yml"
```
