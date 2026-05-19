mock_provider "duplocloud" {
  source = "../../mocks"
}

mock_provider "aws" {
  source = "../../mocks"
}

variables {
  tenant = "shared01"
  name   = "my-api-tester"
  class  = "rest"
}

# only do plans here
run "simple_rest_api" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    class  = var.class
  }

  # verify that the correct rest gfateway is made
  assert {
    condition     = length(aws_api_gateway_rest_api.this) == 1 && length(aws_apigatewayv2_api.this) == 0
    error_message = "There should be one aws_api_gateway_rest_api resource."
  }

  # make sure a deployment is made
  assert {
    condition     = length(aws_api_gateway_deployment.this) == 1
    error_message = "There should be one aws_api_gateway_deployment resource."
  }

  # verify that there is one rest gateway stage and zero http gateway stages
  assert {
    condition     = length(aws_api_gateway_stage.default) == 1 && length(aws_apigatewayv2_stage.default) == 0
    error_message = "There should be one aws_api_gateway_stage resource."
  }

  # by default the vpc link should be disabled
  assert {
    condition     = length(aws_api_gateway_vpc_link.this) == 0 && length(aws_apigatewayv2_vpc_link.this) == 0
    error_message = "There should be no VPC links."
  }

  # now make sure no mappings exist because there are none by default
  assert {
    condition     = length(aws_api_gateway_base_path_mapping.this) == 0 && length(aws_apigatewayv2_api_mapping.this) == 0
    error_message = "There should be no API mappings."
  }

  # there should also be no custom domain names by default
  assert {
    condition     = length(aws_api_gateway_domain_name.this) == 0 && length(aws_apigatewayv2_domain_name.this) == 0
    error_message = "There should be no custom domain names."
  }

  # and finally no records should be made either
  assert {
    condition     = length(aws_route53_record.rest_gateway) == 0 && length(aws_route53_record.http_gateway) == 0
    error_message = "There should be no Route53 records."
  }

}

run "rest_api_with_domain" {
  command = plan
  variables {
    tenant = var.tenant
    name   = var.name
    class  = var.class
    mappings = [{
      domain = "my-app"
    }]
  }

  # make sure the managed_domains object was created correctly
  assert {
    condition     = length(local.managed_domains) == 1 && contains(keys(local.managed_domains), "my-app")
    error_message = "There should be one managed domain for my-app."
  }

  # make sure an embedded domain name was created
  assert {
    condition     = length(aws_api_gateway_domain_name.this) == 1 && contains(keys(aws_api_gateway_domain_name.this), "my-app")
    error_message = "There should be one aws_api_gateway_domain_name resource for my-app."
  }

  # verify the domain_name is using the default suffix
  assert {
    condition     = aws_api_gateway_domain_name.this["my-app"].domain_name == "my-app${local.base_domain}"
    error_message = "The domain_name should be my-app with the base domain suffix."
  }
}
