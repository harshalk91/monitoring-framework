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
  statement {
    sid     = "s3-events-policy"
    actions = ["sqs:SendMessage"]
    condition {
      test     = "ArnEquals "
      values   = "arn:aws:events:us-east-1:745946109524:rule/${aws_cloudwatch_event_rule.s3_event_rule.name}"
      variable = "aws:SourceArn"
    }
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