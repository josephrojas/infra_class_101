terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

variable "imagen_custom" {
  type        = string
  description = "Nombre y tag de la imagen Docker construida localmente"
  default     = "mi-servidor-python:v1"
}

resource "docker_network" "app_network" {
  name = "red_python_local"
}

resource "docker_container" "python_app" {
  name  = "backend_estudiante"
  image = var.imagen_custom

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 5000
    external = 5000
  }
}

output "url_acceso" {
  value       = "http://localhost:5000"
  description = "Abre esta URL en tu navegador"
}