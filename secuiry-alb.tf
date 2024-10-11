#Create launch template with Amazon Linux 2 and run script
resource "aws_launch_template" "launch_template" {
  name = "lt-asg"
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  user_data = filebase64("${path.root}/userdata/userdata.tpl")

  #copy file from local to ec2 instance
  provisioner "file" {
    source      = "${path.root}/userdata/index.html"
    destination = "/tmp/index.html"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
  
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = [aws_security_group.lt_sg.id]
  }
  
}

#Create auto scaling group 
resource "aws_autoscaling_group" "asg" {
  name = "app-asg"
  max_size = 5
  min_size = 2
  desired_capacity = 2
  vpc_zone_identifier = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]
  target_group_arns = [aws_lb_target_group.alb_tg.arn]

  launch_template {
    id = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}


#Create application load balancer
resource "aws_alb" "app_lb" {
  name = "app-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [aws_subnet.pub_sub_1.id, aws_subnet.pub_sub_2.id]
}


#Create and configure the listener for load balancer
resource "aws_alb_listener" "lb_listener" {
  load_balancer_arn = aws_alb.app_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}


#Create the application load balancer target group
resource "aws_lb_target_group" "alb_tg" {
  name = "alb-tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc.id
}


#Display application load balancer dns name
output "dns_name" {
  description = "the DNS name of the alb"
  value = aws_alb.app_lb.dns_name
}