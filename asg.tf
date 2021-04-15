data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

data "template_file" "ecs_config" {
  template = file("ecs.config.tpl")
  vars = {
    ECS_CLUSTER = aws_ecs_cluster.ecs_cluster.name
  }
}

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "${local.resource_prefix}-lt"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  user_data              = base64encode(data.template_file.ecs_config.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_iam_ip.name
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                = "${local.resource_prefix}-asg"
  max_size            = var.max_ec2_instance_count
  min_size            = var.min_ec2_instance_count
  vpc_zone_identifier = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "ecs_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.id
  alb_target_group_arn   = aws_lb_target_group.ecs_lb_tg.arn
}

resource "aws_autoscaling_policy" "ecs_asg_policy" {
  name                   = "${local.resource_prefix}-asg-policy"
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
}