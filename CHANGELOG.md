# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
