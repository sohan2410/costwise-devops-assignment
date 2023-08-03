provider "aws" {
  region = "ap-south-1"  # Replace with your desired AWS region
}

# Create a security group for EC2 instance and RDS
resource "aws_security_group" "ec2_rds_sg" {
  name_prefix = "ec2-rds-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow any IP address for SSH (port 22) for EC2 Instance Connect.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0  # Allow all ports
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an RDS subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = ["subnet-0b2ce29f3320d4ee1","subnet-0f041cfedfbf62a26","subnet-08a622ff4959cd464"]  # Replace with your subnet IDs
}


# Create an RDS instance (MySQL engine)
resource "aws_db_instance" "rds_instance" {
  identifier           = "my-rds-instance"
  engine               = "mysql"
  instance_class       = "db.t4g.micro"
  allocated_storage    = 20
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.ec2_rds_sg.id]
  publicly_accessible  = false
  username             = "admin"
  password             = "password"  # Replace with your desired password
  skip_final_snapshot  = true  # Skip the final snapshot when terminating the RDS instance

  # Create a database named "my_wordpress_db"
  db_name               = "my_wordpress_db"
}

# Create an EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-077053fb4029de92f"  # Replace with the ARM-based AMI ID
  instance_type = "t4g.micro"
  subnet_id     = "subnet-0b2ce29f3320d4ee1"
  # security_groups = [aws_security_group.ec2_rds_sg.name]
  vpc_security_group_ids = [aws_security_group.ec2_rds_sg.id]

  user_data = <<-EOF
#!/bin/bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

sudo docker pull wordpress:php7.4-fpm
sudo docker run -d --name wordpress_container -p 80:80 -e WORDPRESS_DB_HOST=${aws_db_instance.rds_instance.endpoint} -e WORDPRESS_DB_USER=admin -e WORDPRESS_DB_PASSWORD=password -e WORDPRESS_DB_NAME=my_wordpress_db wordpress:php7.4-fpm
EOF
}

# Create an Elastic IP and associate it with the EC2 instance
resource "aws_eip" "ec2_eip" {
  instance = aws_instance.ec2_instance.id
}

