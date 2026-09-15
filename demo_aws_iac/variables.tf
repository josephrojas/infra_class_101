variable "aws_region" {
  type        = string
  description = "Región de AWS donde se desplegarán los recursos"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Ambiente de despliegue (dev, qa, prod)"
  default     = "production"
}

variable "instance_type" {
  type        = string
  description = "Tipo de instancia EC2"
  default     = "t3.micro"
}

variable "db_name" {
  type        = string
  description = "Nombre de la base de datos de PostgreSQL"
  default     = "demodb"
}

variable "db_user" {
  type        = string
  description = "Usuario administrador de PostgreSQL"
  default     = "adminuser"
}

variable "db_password" {
  type        = string
  description = "Contraseña para la base de datos"
  sensitive   = true
}