#Create security group for launch template to allow http and ssh 
resource "aws_security_group" "lt_sg" {
  name        = "launchtemp-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_open]
  }

  ingress {
    description      = "https"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_open]
  }

  egress {
    description      = "Outgoing"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_open]
  }

  tags = {
    Name = "launchtemp-sg"
  }
}