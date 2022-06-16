resource "aws_cloudwatch_event_rule" "generic_event_rule" {
  name          = var.event_rule_name
  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["stopping"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.generic_event_rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.generic_events.arn
}

resource "aws_sns_topic" "generic_events" {
  name = "generic-topic"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.generic_events.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.generic_events.arn]
  }
}
