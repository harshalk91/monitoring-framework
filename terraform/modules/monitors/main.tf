resource "aws_cloudwatch_metric_alarm" "metric-alarm" {
  count = length(var.alarm_name)
  alarm_name          = element(var.alarm_name, count.index)
  comparison_operator = var.comparison_operator
  evaluation_periods  = element(var.evaluation_periods, count.index)
  metric_name         = element(var.metric_name, count.index)
  namespace           = var.namespace
  period              = element(var.period, count.index)
  statistic           = var.statistic
  threshold           = element(var.threshold, count.index)
  alarm_description   = var.alarm_description
  alarm_actions       = [var.sns_topic_arn]
  ok_actions          = [var.sns_topic_arn]
  tags                = var.tags
}