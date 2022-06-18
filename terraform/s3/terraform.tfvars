comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods  = [1, 1]
metric_name         = ["NumberOfObjects", "BucketSizeBytes"]
namespace           = "AWS/S3"
period              =  [86400, 86400]
statistic           = "Sum"
threshold           = [10000, 15000]
alarm_description   = "test alarms"
