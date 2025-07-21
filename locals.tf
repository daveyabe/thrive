locals {
  common_tags = {
    project     = "${var.project}"
    environment = var.environment
  }

  naming_prefix = "${var.naming_prefix}-${var.environment}"
}