locals {
  alarm_name          = ["${var.instance_id}_NetworkOut", "${var.instance_id}_CPUUtilisation", "${var.instance_id}_StatusCheckFailed"]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = [1, 1, 2]
  metric_name         = ["DiskReadOps", "NetworkOut", "CPUUtilisation"]
  namespace           = "AWS/EC2"
  period              =  [120, 60, 120]
  statistic           = "Average"
  threshold           = [10000, 15000, 70]
  alarm_description   = "test alarms"
}


resource "aws_cloudwatch_metric_alarm" "metric-alarm" {
  count = length(local.alarm_name)
  alarm_name          = element(local.alarm_name, count.index)
  comparison_operator = local.comparison_operator
  evaluation_periods  = element(local.evaluation_periods, count.index)
  metric_name         = element(local.metric_name, count.index)
  namespace           = local.namespace
  period              = element(local.period, count.index)
  statistic           = local.statistic
  threshold           = element(local.threshold, count.index)
  alarm_description   = local.alarm_description
  tags = {
    mapped_to = var.instance_id
  }
}