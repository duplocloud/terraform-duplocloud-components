# To test this, we need to query a real portal and AWS account and make sure the expected data comes back. Deploying
# unique test environments where we could do that would be slow and expensive. Instead, we keep the tests light by
# asserting on the format of outputs instead of specific values so they can be run against any test environment where
# the VPN is enabled in the portal's default region. The module is written to handle portals with disabled VPNs and
# VPNs in other regions, but there were no available test environments for these cases when these tests were added.

provider "aws" {
  alias = "vpn_region"

  access_key = run.setup.credentials.access_key_id
  region     = run.setup.credentials.region
  secret_key = run.setup.credentials.secret_access_key
  token      = run.setup.credentials.session_token
}

# See this doc for the 'setup' pattern:
# https://developer.hashicorp.com/terraform/language/tests#modules
run "setup" {

  command = plan

  module {
    source = "./tests/setup"
  }
}

run "vpn_enabled" {

  command = plan

  assert {
    condition     = output.enabled
    error_message = "VPN should be enabled."
  }

  assert {
    # This relies on the cidrnetmask function to fail if we give it something that's not an IP address.
    condition     = can(cidrnetmask("${output.private_ip}/32"))
    error_message = "Private IP should be a valid IPv4 address"
  }

  assert {
    condition     = can(regex("^(10\\.|172\\.(1[6-9]|2[0-9]|3[0-1])\\.|192\\.168\\.)", output.private_ip))
    error_message = "Private IP should be in RFC 1918 ranges https://datatracker.ietf.org/doc/html/rfc1918#section-3)"
  }

  assert {
    # This relies on the cidrnetmask function to fail if we give it something that's not an IP address.
    condition     = can(cidrnetmask("${output.public_ip}/32"))
    error_message = "Public IP should be a valid IPv4 address"
  }

  assert {
    condition     = !can(regex("^(10\\.|172\\.(1[6-9]|2[0-9]|3[0-1])\\.|192\\.168\\.)", output.public_ip))
    error_message = "Public IP should NOT be in RFC 1918 private ranges https://datatracker.ietf.org/doc/html/rfc1918#section-3)"
  }
}
