# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
data "aws_iam_policy_document" "ecs_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_iam_role" {
  name               = "${local.resource_prefix}-ir"
  assume_role_policy = data.aws_iam_policy_document.ecs_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_iam_role_pa" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_iam_ip" {
  name = "${local.resource_prefix}-ip"
  role = aws_iam_role.ecs_iam_role.name
}