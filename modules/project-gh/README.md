# Duploclouds Github Project  

This module is representative of a single project within your stack. The repo within Github may be managed by this module directly or you can use this in an unmanaged way and this module will operate based on values set on the properties of the repository, ie you still create the repo in the Github UI and this module just reads the data. The purpose of the repo is to be a data set and manager of Action Workflows and Rulesets. 


## Workflows  

Here is an example of creating a custom workflow with your own template and conditions. 

```hcl
module "project" {
  name   = "my-repo"
  owner  = "my-org"
  class  = "service"
  mode   = "data"
  workflows = {
    image = {
      context = {
        use_app = false
      }
    }
  }
}
```
