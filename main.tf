# AWS Public and Private Key Generate

resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {

  # Name of key : Write the custom name of your key
  key_name = "tfkey"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > tfkey.pem
      #chmod 400 tfkey.pem
    EOT
  }
}

# IAM Role Creation for Terraform-Instance.

resource "aws_iam_role" "admin_role" {
  name                = "tf_admin_role"
  managed_policy_arns = var.policy_arn_list

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# IAM iam_instance_profile for my Instance.

resource "aws_iam_instance_profile" "instance_profile" {
  name = "tf_instance_profile"
  role = aws_iam_role.admin_role.name
}


# AWS EC2 Instance Creation

resource "aws_instance" "web" {
  ami                  = "ami-06878d265978313ca"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  key_name             = "tfkey"
  tags = {
    Name = "Terraform-Instance"
  }
}

# Output section:
output "instance_info" {
  value = [aws_instance.web.id,
    aws_instance.web.instance_type,
  aws_instance.web.public_ip]
}

output "IAM_info" {
  value = aws_iam_role.admin_role.arn
}

