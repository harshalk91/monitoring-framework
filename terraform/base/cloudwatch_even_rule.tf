resource "aws_cloudwatch_event_rule" "ec2_event_rule" {
  name          = var.ec2_event_rule_name
  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated", "running"]
  }
}
EOF
}

resource "aws_cloudwatch_event_rule" "s3_event_rule" {
  name          = var.s3_event_rule_name
  event_pattern = <<EOF
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["s3.amazonaws.com"],
    "eventName": ["CreateBucket", "DeleteBucket"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "ec2_sqs_target" {
  rule      = aws_cloudwatch_event_rule.ec2_event_rule.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.standard_queue.arn
}

resource "aws_cloudwatch_event_target" "s3_sqs_target" {
  rule      = aws_cloudwatch_event_rule.s3_event_rule.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.standard_queue.arn
}
