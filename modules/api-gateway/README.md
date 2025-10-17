# API Gateway  

Creates a Duplocloud style API Gateway with the AWS provider. This module supports both HTTP, REST, and WebSocket API Gateway types. The main pattern here is to feed the module the OpenAPI object to this module and have it do the heavy lifting of creating the API Gateway, stages, deployments, domain names, and route53 records. Now you can focus on the logic within your OpenAPI file. 
