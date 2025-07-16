# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- API Gateway module fails on duplicate SID statements when allowing exec permissions on lambda endpoints
- API Gateway logic on vpc link creation resulted in opposite of desired behavior
- API Gateway would fail on non-lambda integrations like 'mock'.
### Configuration Module 

- new `external` variable that omits creating a resource and only outputs the configurations for a service. 
- new `remapped` variabled to change what the names of the variables/files are when mounted to the pod. This causes configurations to output env vars instead of envFrom. 
- new type named `reference` which means the configuration is only referenced by name in the code
- new gcp secret which just makes a tenant secret

### Micro Service Module 

- ignore some generated values causing too many unneccessary chagnes to plan when GCP. 
- new sidecars variable for adding more containers to run in your service.  
- new `debug` variable to enable when a container is crashing and you need to investigate.  
- new `container_lifecycle` variable to add lifecycle hooks to the container.
- All probes are now exposed under `health_check` variable. The top level values are the defaults for all of them, but you can override them individually.  
- **BREAKING** The id of the configurations has changed from only the name to be like `<class>/<name>` format so that multiple configurations may be named the same. Use the following `moved` snippet to migrate the configurations to the new id model.  
```hcl
moved {
  from = module.service.configurations["env"]
  to   = module.service.configurations["configmap/env"]
}
```

### Tenant Module 

- output the namespace for convenience
- properly copy missing vars into extended tenant modules

### Context Module  

- Can now override the Terraform state bucket name with the `StateBucket` AppConfig set on the portal. Otherwise it will continue to guess the standard bucket name which comes with a portal. 

## [0.0.40] - 2025-05-28

### Added

- new website module for gcp

### Fixed

- For the context module the jit is an input and output now so the names match up. So referencing jit creds will be like `module.ctx.jit.aws`.
- node refreshing and templates for the eks node module.

## [0.0.39] - 2025-05-07

### Fixed

- reversed tenant deletion logic handeling

## [0.0.38] - 2025-05-07

### Added

- a `release_header` rule under `lb` in the micro-service module. When enabled will add the release ID as a required value in the `X-Access-Control` header for the load balancer.
- exposed annotations on the lb variable for micro-service
- Added termination grace period as an option in the microservices module
- On the micro-service module, jobs can individually override the timeouts, env vars, labels, and annotations.
- added the following fields to nodes on the micro-service; `unique` and `spread_across_zones`
- micro-service now outputs the follwoing fields: domain, parent_domain, image, name, namespace

### Fixed

- cert arn local did not match on govcloud cert arns
- service params removed for ingress resources to conflict on dns_prfx
- lbconfigs for clusterip services should use var.port as external_port instead of computed value.
- micro-service jobs were not properly using the allocation tags and nodeSelector from the `nodes` field
- parameterized `allow_deletion` which will be the same value with `deletion_protection`

## [0.0.37] - 2025-04-09

### Added

- new mongodb module to create mongodb atlas resources.

### Fixed

- context module now supports gcp, it was very specific to aws before. It might work with azure too.

## [0.0.36] - 2025-03-28

### Fixed

- Default the health checks to http instead of just tcp so path is actually used.
- the service template is yaml now

## [0.0.35] - 2025-03-27

### Added

- A new infrastructure module that blends the plan and infra into one along with a bunch of little subcomponents like certs and settings.
- tenants can add grants from their parents or to their siblings
- tenants now output the volumes, volumeMounts, and envFrom for the configurations
- refactored configuration module a bit to make it easier to read
- auto discover next valid cidr when no cidr is given to an infrastructure


## [0.0.34] - 2025-03-14

### Added

- A new context module that can get jit credentials and information about the current portal, infra, and tenant. It can also make references to other workspaces very easily.
- new tenant module which includes sg_rules and settings to add
- a new tenant-gh-aws modules for making a tenant when using aws and github.

## [0.0.33] - 2025-03-11

### Added

- a parser for env files in a new module
- added aws-ssm-secure and aws-ssm-list as classes to use
- a submodule under configurations called github. This way we have configurations for github as well with their own nuances.

## [0.0.32] - 2025-03-11

### Added

- new hpa specs feature and resources on micro-service module. Warning is given when hpa is given without resources.

### Fixed

- in the loadbalancer module on the lbconfig the `backend_protocol_version` is now ignored to prevent getting recreated.

## [0.0.30] - 2025-03-05

- cleaned up the publish flow
- badges to readme and release notes

## [0.0.26] - 2025-03-05

### Added

- micro-service module
- configuration module
- better release flow
