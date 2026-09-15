> **ADVERTENCIA IMPORTANTE DE ENTORNOS LOCALES**
> **ESTE CONFIGURACIÓN TIENE FINES EXCLUSIVAMENTE DIDÁCTICOS Y DE PRUEBA DE CONCEPTO.**
> El código utilizado en este taller ha sido simplificado para ejecutarse en entornos de desarrollo local utilizando Docker y Terraform. Presenta limitaciones intencionales como:
> * Servidor web monolítico ejecutado directamente sobre el intérprete de Python sin un servidor de aplicación WSGI/ASGI de grado de producción (como Gunicorn o Uvicorn).
> * Ausencia de cifrado SSL/TLS (tráfico en texto plano por HTTP en el puerto 5000).
> * Exposición directa de puertos locales sin intermediación de un proxy inverso o balanceador de carga.
> 
> 
> **NO utilice esta configuración de contenedor ni la arquitectura de despliegue en entornos reales de producción.**

---

# Guía de Despliegue de Infraestructura Local con Terraform y Docker

## 1. Requisitos Previos

Asegúrese de contar con las siguientes herramientas instaladas y ejecutándose en su equipo personal antes de iniciar el taller:

1. **Docker Desktop** (en Windows/macOS) o **Docker Engine** (en Linux). Debe estar iniciado y funcional.
2. **Terraform CLI** (versión 1.3.0 o superior).

Verifique la disponibilidad de las herramientas ejecutando los siguientes comandos en su terminal:

```bash
docker --version
terraform --version

```

---

## 2. Estructura del Proyecto y Archivos de Código

Cree una carpeta llamada `taller_iac_docker` en su equipo y asegúrese de incluir los siguientes tres archivos dentro del directorio raíz:

```text
taller_iac_docker/
├── app.py
├── Dockerfile
└── main.tf

```

### Archivo 2.1: `app.py`

Servidor HTTP básico desarrollado en Python nativo:

```python
from http.server import HTTPServer, BaseHTTPRequestHandler

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()
        mensaje = "<h1>Servidor Python Custom | Desplegado con Terraform y Docker</h1>"
        self.wfile.write(mensaje.encode('utf-8'))

print("Iniciando servidor en puerto 5000...")
server = HTTPServer(('0.0.0.0', 5000), SimpleHandler)
server.serve_forever()

```

### Archivo 2.2: `Dockerfile`

Instrucciones de empaquetado para la creación de la imagen del contenedor:

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]

```

### Archivo 2.3: `main.tf`

Declaración de infraestructura utilizando el proveedor de Docker para Terraform:

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

# Variable para definir la imagen que construirá el desarrollador
variable "imagen_custom" {
  type        = string
  description = "Nombre y etiqueta de la imagen Docker local"
  default     = "mi-servidor-python:v1"
}

# 1. Creación de una red privada virtual local
resource "docker_network" "app_network" {
  name = "red_python_local"
}

# 2. Despliegue del contenedor asociado a la red y mapeo de puertos
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
  description = "Dirección URL para probar el servicio localmente"
}

```

---

## 3. Paso a Paso para la Ejecución del Taller

### Paso 3.1: Construcción de la Imagen Docker (Fase de Desarrollo)

Abra una terminal dentro del directorio `taller_iac_docker` y compile la imagen de la aplicación ejecutando el comando de empaquetado:

```bash
docker build -t mi-servidor-python:v1 .

```

Verifique que la imagen se haya registrado correctamente en el registro local:

```bash
docker images | grep mi-servidor-python

```

---

### Paso 3.2: Inicialización de Terraform

Descargue e instale el proveedor local de Docker configurado en el archivo `main.tf`:

```bash
terraform init

```

---

### Paso 3.3: Previsualización de Cambios

Verifique las acciones que Terraform realizará en el motor de Docker de su máquina:

```bash
terraform plan -var="imagen_custom=mi-servidor-python:v1"

```

---

### Paso 3.4: Aplicación y Despliegue de la Infraestructura

Ejecute la creación de la red y el contenedor inyectando el nombre de la imagen mediante la variable:

```bash
terraform apply -var="imagen_custom=mi-servidor-python:v1" -auto-approve

```

---

### Paso 3.5: Verificación del Servicio

1. Abra su navegador web.
2. Ingrese a la URL expuesta por la salida de Terraform: `http://localhost:5000`
3. Confirme que la interfaz devuelva el mensaje generado por el script en Python.

---

### Paso 3.6: Limpieza del Entorno

Al finalizar la práctica, elimine el contenedor y la red virtual creados para liberar los recursos del sistema:

```bash
terraform destroy -var="imagen_custom=mi-servidor-python:v1" -auto-approve

```