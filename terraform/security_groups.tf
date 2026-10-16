resource "aws_security_group" "alb" {
  name        = "shopnova-alb-sg"
  description = "Allow HTTP and HTTPS from the internet to the load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shopnova-alb-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "shopnova-app-sg"
  description = "Allow app traffic only from the load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "App port from the load balancer only"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shopnova-app-sg"
  }
}

resource "aws_security_group" "db" {
  name        = "shopnova-db-sg"
  description = "Allow Postgres traffic only from the app servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Postgres from the app only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = {
    Name = "shopnova-db-sg"
  }
}
