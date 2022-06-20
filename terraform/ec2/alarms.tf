locals {
  alarm_name          = ["${var.instance_id}_DiskReadOps", "${var.instance_id}_NetworkOut", "${var.instance_id}_CPUUtilisation"]
}

data "aws_sns_topic" "sre_topic" {
  name = "sre"
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
  sns_topic_arn       = data.aws_sns_topic.sre_topic.arn
  tags = {
    "mapped_to": var.instance_id
  }
}