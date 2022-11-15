resource "aws_cloudwatch_log_group" "update_security_groups_lambda_log" {
  name              = "/aws/lambda/${aws_lambda_function.update_security_group_rules.function_name}"
  kms_key_id        = aws_kms_key.this
  retention_in_days = 14
  tags              = var.input_tags
}



locals {
  kms_allowed_accounts = compact([data.aws_caller_identity.current.account_id])
}

resource "aws_kms_key" "this" {
  description         = "Key used to encrypt cloudwatch log group"
  tags                = var.input_tags
  policy              = data.aws_iam_policy_document.this.json
  enable_key_rotation = true
}

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = local.kms_allowed_accounts
    content {
      sid    = "Enable IAM Permissions from ${statement.value}"
      effect = "Allow"
      principals {
        identifiers = ["arn:aws:iam::${statement.value}:root"]
        type        = "AWS"
      }
      actions   = ["kms:*"]
      resources = ["*"]
    }
  }
}