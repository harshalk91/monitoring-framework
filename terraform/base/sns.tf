resource "aws_sns_topic" "developer" {
  name = "developer"
}

resource "aws_sns_topic_subscription" "developer_alert" {
  topic_arn = aws_sns_topic.developer.arn
  protocol  = "email"
  endpoint  = "harshalk.91@gmail.com"
  endpoint_auto_confirms = true
}

resource "aws_sns_topic" "sre" {
  name = "sre"
}

resource "aws_sns_topic_subscription" "sre_alert" {
  topic_arn = aws_sns_topic.sre.arn
  protocol  = "email"
  endpoint  = "harshalk91aws@gmail.com"
  endpoint_auto_confirms = true
}
