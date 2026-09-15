output "url_aplicacion" {
  value       = "http://${aws_instance.web_server.public_ip}"
  description = "URL pública para acceder al frontend"
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.app_bucket.bucket
  description = "Nombre del bucket S3 generado"
}

output "rds_endpoint" {
  value       = aws_db_instance.database.endpoint
  description = "Endpoint de conexión a la base de datos"
}