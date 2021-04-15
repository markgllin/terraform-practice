resource "aws_cloudwatch_metric_alarm" "CPUOver1" {
  alarm_name          = "[${local.resource_prefix}] High CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  period              = "300"
  statistic           = "Average"
  threshold           = "1.0"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  alarm_description   = "CPU Over 1%"

  alarm_actions = [
    aws_sns_topic.cw_sns_topic.arn,
    aws_autoscaling_policy.ecs_asg_policy.arn
  ]

  dimensions = {
    ClusterName          = aws_ecs_cluster.ecs_cluster.name
    AutoScalingGroupName = aws_autoscaling_group.ecs_asg.name
  }

}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish",
      "SNS:Receive"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [aws_sns_topic.cw_sns_topic.arn]
  }
}

resource "aws_sns_topic" "cw_sns_topic" {
  name = "${local.resource_prefix}-sns-topic"
}

resource "aws_sns_topic_subscription" "cw_email_subscription" {
  topic_arn = aws_sns_topic.cw_sns_topic.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
