resource "aws_sqs_queue" "standard_queue" {
  name = "monitoring-queue"
  delay_seconds = "5"
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
