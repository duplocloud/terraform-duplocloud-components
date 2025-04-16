# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added 

- On the micro-service module, jobs can individually override the timeouts, env vars, labels, and annotations.
- added the following fields to nodes on the micro-service; `unique` and `spread_across_zones`
- micro-service now outputs the follwoing fields: domain, parent_domain, image, namespace

### Fixed

- cert arn local did not match on govcloud cert arns
- service params removed for ingress resources to conflict on dns_prfx
- lbconfigs for clusterip services should use var.port as external_port instead of computed value.
- micro-service jobs were not properly using the allocation tags and nodeSelector from the `nodes` field

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
