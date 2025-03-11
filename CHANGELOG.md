# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
