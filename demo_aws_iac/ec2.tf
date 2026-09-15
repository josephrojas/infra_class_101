# Buenas prácticas: Consultar la última AMI oficial dinámicamente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    db_host = aws_db_instance.database.address
    db_name = aws_db_instance.database.db_name
    db_user = aws_db_instance.database.username
    db_pass = aws_db_instance.database.password
    s3_url  = "https://${aws_s3_bucket.app_bucket.bucket_regional_domain_name}/${aws_s3_object.sample_image.key}"
  })

  tags = {
    Name = "${var.environment}-Live-Demo-AWS-App"
  }
  depends_on = [ aws_s3_bucket.app_bucket, aws_db_instance.database ]
}