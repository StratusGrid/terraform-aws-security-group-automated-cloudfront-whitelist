<!-- BEGIN_TF_DOCS -->
# terraform-aws-security-group-automated-cloudfront-whitelist

GitHub: [StratusGrid/terraform-aws-security-group-automated-cloudfront-whitelist](https://github.com/StratusGrid/terraform-aws-security-group-automated-cloudfront-whitelist)

This module provisions new security groups for allowing ingress traffic over ports 80/tcp and 443/tcp from all global and applicable regional Amazon CloudFront published IP address ranges. The security groups are updated automatically any time the published IP address ranges (https://ip-ranges.amazonaws.com/ip-ranges.json) are updated.

### Prerequisite:
Make sure to open an AWS service quota request to increase the size of rules allowed on Security Groups. Cloudfront has more IPs to add to the security groups than the default allowance. AWS usually allows you to request up to 200 rules without issue.

<span style="color:red">Note:</span> Mac users need to install "md5sha1sum" package locally using the following command.
```bash
brew install md5sha1sum
```
---
## Example
Create a Lamba function and related security groups to permit http and https traffic
```hcl
module "cloudfront-security-groups" {
    source               = "./modules/cloudfront-security-groups"

    aws_region           = "us-east-1"
    ec2_sg_name_global   = "cf_global_a"
    ec2_sg_name_regional = "cf_global_b"
    vpc_id               = "vpc-1a1a1a1a"
}
```
---
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.update_security_groups_lambda_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.allow_cloudwatch_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.allow_security_group_describe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.allow_security_group_ingress_rules_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.update_ec2_sg_ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.allow_ingress_rule_update](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.allow_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.describe_ec2_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.update_security_group_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_invocation_by_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_security_group.allow_cloudfront_global_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_cloudfront_regional_ips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_sns_topic_subscription.amazon_ip_space_changed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [null_resource.invoke_lambda_function](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which the VPC and all related resources will be created. | `string` | n/a | yes |
| <a name="input_ec2_sg_name_global"></a> [ec2\_sg\_name\_global](#input\_ec2\_sg\_name\_global) | Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront global IP address ranges. Will be suffixed by permitted protocol. | `string` | `"allow-cloudfront-global-ips"` | no |
| <a name="input_ec2_sg_name_regional"></a> [ec2\_sg\_name\_regional](#input\_ec2\_sg\_name\_regional) | Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront regional IP address ranges. Will be suffixed by permitted protocol. | `string` | `"allow-cloudfront-regional-ips"` | no |
| <a name="input_input_tags"></a> [input\_tags](#input\_input\_tags) | Map of tags to apply to all taggable resources. | `map(string)` | <pre>{<br>  "Developer": "GenesisFunction",<br>  "Provisioner": "Terraform"<br>}</pre> | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | The name of the Lambda function used to create security groups and rules. | `string` | `"update-security-group-rules"` | no |
| <a name="input_permitted_protocols"></a> [permitted\_protocols](#input\_permitted\_protocols) | List of protocols to be allowed ingressly from CloudFront. Only http and https are currently supported. | `set(string)` | <pre>[<br>  "http",<br>  "https"<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of target VPC in which to create security groups and rules. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_global_security_groups"></a> [cloudfront\_global\_security\_groups](#output\_cloudfront\_global\_security\_groups) | Security groups created to allow ingress traffic from Amazon CloudFront global IP address ranges. |
| <a name="output_cloudfront_regional_security_groups"></a> [cloudfront\_regional\_security\_groups](#output\_cloudfront\_regional\_security\_groups) | Security groups created to allow ingress traffic from Amazon CloudFront regional IP address ranges. |
| <a name="output_cloudfront_security_groups"></a> [cloudfront\_security\_groups](#output\_cloudfront\_security\_groups) | Security groups created to allow ingress traffic from all Amazon CloudFront IP address ranges. |
| <a name="output_cloudfront_security_groups_by_protocol"></a> [cloudfront\_security\_groups\_by\_protocol](#output\_cloudfront\_security\_groups\_by\_protocol) | Security groups created to allow ingress traffic from all Amazon CloudFront IP address ranges. Grouped by protocol. |
| <a name="output_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#output\_cloudwatch\_log\_group) | CloudWatch log for the Lambda function for update security group ingress rules. |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | IAM role assigned to the Lambda function for updating security group ingress rules. |
| <a name="output_lambda_function"></a> [lambda\_function](#output\_lambda\_function) | Lambda function for updating security group ingress rules. |
| <a name="output_sns_subscription"></a> [sns\_subscription](#output\_sns\_subscription) | SNS topic subscription used to trigger Lambda function. |

---

<span style="color:red">Note:</span> Manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml .`
<!-- END_TF_DOCS -->