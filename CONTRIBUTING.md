# Contributing  

Read this to get started working on this repo. 

## Formatting  

In each module run:  
```sh
tf fmt -recursive
```

For the git webhook we need to add the following to `.git/config` in this repo. 
```toml
[filter "tf-fmt"]
  clean = "terraform fmt -"
```  
Run this command to add the filter:
```sh
git config filter.tf-fmt.clean "terraform fmt -"
```
