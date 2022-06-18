resource "aws_cloudwatch_event_rule" "generic_event_rule" {
  name          = var.event_rule_name
  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["stopping", "running"]
  }
}
EOF
}

resource "aws_sqs_queue" "standard_queue" {
  name = "monitoring-queue"
  delay_seconds = "30"
}

data "aws_iam_policy_document" "queue" {
  statement {
    sid     = "events-policy"
    actions = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = [
      aws_sqs_queue.standard_queue.arn
    ]
  }
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.standard_queue.id
  policy    = data.aws_iam_policy_document.queue.json
}

resource "aws_cloudwatch_event_target" "sqs_target" {
  rule      = aws_cloudwatch_event_rule.generic_event_rule.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.standard_queue.arn
}
