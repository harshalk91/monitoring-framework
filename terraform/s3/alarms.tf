locals {
  alarm_name          = ["${var.bucket_name}_NumberOfObjects", "${var.bucket_name}_BucketSizeBytes"]
}

module "ec2_monitors" {
  source = "../modules/monitors"
  alarm_name          = local.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  alarm_description   = var.alarm_description
  tags = {
    "mapped_to": var.bucket_name
  }
}