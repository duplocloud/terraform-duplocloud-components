# Duplocloud Tenant with Github    

If you are using Github as your repository and use Github Actions, then this is the tenant module for you. By providing a list of repository names, each will get a matching [Github Actions Environment](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment) created. 

## Providers  

As this is a mashup it requires the following fully authenticated providers. 

- [`duplocloud`](https://registry.terraform.io/providers/duplocloud/duplocloud/latest/docs) - The Duplocloud provider.
- [`github`](https://registry.terraform.io/providers/integrations/github/latest/docs) - The Github provider.

## Submodules 

This module is a combination of the following submodules so that Github, AWS, and Duplocloud can all be synchronized together. The github integration is baked into this one. 

- [tenant](../tenant/README.md)
