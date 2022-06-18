comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods  = [1, 1, 2]
metric_name         = ["DiskReadOps", "NetworkOut", "CPUUtilisation"]
namespace           = "AWS/EC2"
period              =  [120, 60, 120]
statistic           = "Average"
threshold           = [10000, 15000, 70]
alarm_description   = "test alarms"
