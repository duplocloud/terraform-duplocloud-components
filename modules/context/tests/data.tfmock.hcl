mock_data "external" {
  defaults = {
    result = {
      host  = "https://duplo.example.com"
      token = "sometoken"
    }
  }
}

mock_data "http" {
  defaults = {
    response_body = <<EOT
{
  "DefaultAwsAccount": "813590939111",
  "DefaultAwsPartition": "aws",
  "DefaultAwsRegion": "us-west-2",
  "DefaultInfraCloud": "AWS",
  "IsAwsCloudEnabled": true,
  "IsAzureCloudEnabled": false,
  "IsGoogleCloudEnabled": false
}
EOT
  }
}

mock_data "duplocloud_tenant" {
  defaults = {
    id      = "1234567890"
    name    = "tf-tests"
    plan_id = "myinfra"
  }
}
mock_data "duplocloud_infrastructure" {
  defaults = {
    vpc_name   = "myvpc"
    vpc_id     = "vpc-12345678"
    region     = "us-east-1"
    infra_name = "myinfra"
    account_id = "1234567890"
  }
}

mock_data "duplocloud_admin_aws_credentials" {
  defaults = {
    access_key        = "myaccesskey"
    secret_access_key = "mysecretaccess"
    session_token     = "mysession"
  }
}

mock_data "duplocloud_tenant_aws_credentials" {
  defaults = {
    access_key        = "myaccesskey"
    secret_access_key = "mysecretaccess"
    session_token     = "mysession"
  }
}

mock_data "duplocloud_eks_credentials" {
  defaults = {
    endpoint            = "https://mycluster.com"
    ca_certificate_data = "mycert"
    token               = "sometoken"
  }
}

mock_data "duplocloud_tenant_eks_credentials" {
  defaults = {
    endpoint            = "https://mycluster.com"
    ca_certificate_data = "mycert"
    token               = "sometoken"
  }
}
