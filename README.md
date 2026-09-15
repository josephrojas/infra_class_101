# Workshop: De Bare Metal a Cloud Infrastructure as Code (IaC)

Este repositorio contiene los materiales, guías y código fuente para el taller práctico de Infraestructura de TI, diseñado para guiar a los estudiantes en la transición desde entornos físicos (bare metal) hacia la virtualización y la automatización en la nube mediante Infraestructura como Código (IaC).

---

## 1. Estructura del Repositorio

```text
.
├── demo_1/
│   └── README.md              # Guía de despliegue manual y scripts de inicio (AWS/GCP)
├── demo_aws_iac/              # Demostración modular de arquitectura en AWS con Terraform
│   ├── images/
│   │   └── mi_imagen.jpeg     # Archivo de imagen estático subido a S3
│   ├── templates/
│   │   └── user_data.sh.tftpl # Plantilla bash de inicialización para EC2
│   ├── ec2.tf                 # Recurso de cómputo y consulta de AMIs
│   ├── rds.tf                 # Base de datos gestionada (PostgreSQL)
│   ├── s3.tf                  # Bucket y políticas de almacenamiento de objetos
│   ├── security.tf            # Reglas de cortafuegos (Security Groups)
│   ├── providers.tf           # Configuración del proveedor de AWS y versiones
│   ├── variables.tf           # Declaración de variables de entrada
│   ├── terraform.tfvars       # Asignación de valores para variables
│   ├── outputs.tf             # Salidas formateadas (IPs públicas, endpoints)
│   ├── terraform.tfstate      # Estado actual de la infraestructura desplegada
│   ├── terraform.tfstate.backup # Copia de respaldo del estado de Terraform
│   └── README.MD              # Instrucciones detalladas de la demo en AWS
├── taller_iac_local/          # Práctica individual para estudiantes (Entorno Local)
│   ├── app.py                 # Servidor HTTP en Python sin dependencias
│   ├── Dockerfile             # Definición del contenedor de la aplicación
│   ├── main.tf                # Provisión de contenedor y red con Terraform
│   └── README.MD              # Guía paso a paso del taller local
└── README.md                  # Documentación principal del repositorio

```

---

## 2. Requisitos Previos

Para ejecutar los módulos de este workshop se requiere tener instaladas las siguientes herramientas en el equipo local:

* **Docker Desktop / Docker Engine:** Versión 20.10 o superior (para `taller_iac_local`).
* **Terraform CLI:** Versión 1.3.0 o superior.
* **AWS CLI:** Versión 2.0 o superior (para `demo_aws_iac`).

---

## 3. Contenido del Workshop

### Módulo 1: `demo_1/` (Despliegue Manual vs. Scripts)

Comparativa directa entre la provisión paso a paso desde las consolas web de AWS y GCP frente a la automatización mediante scripts de arranque (`user_data` y `startup-script`).

### Módulo 2: `taller_iac_local/` (Práctica con Terraform y Docker)

Taller individual enfocado en los estudiantes. Cada alumno construye una imagen de Docker para una app web en Python y utiliza Terraform para orquestar los contenedores, puertos y redes dentro de su propia computadora.

### Módulo 3: `demo_aws_iac/` (Infraestructura Nube Modular)

Demostración en vivo de una arquitectura multi-servicio en AWS provisionada de forma declarativa con Terraform:

* Almacenamiento público de imágenes en Amazon S3.
* Persistencia de datos en una base de datos relacional Amazon RDS (PostgreSQL).
* Instancia de cómputo Amazon EC2 ejecutando la aplicación que consume S3 y RDS.
* Aislamiento mediante Security Groups y organización del código en múltiples archivos.

---

## 4. Aviso de Seguridad

> **IMPORTANTE:** El código contenido en este repositorio fue diseñado exclusivamente con fines pedagógicos y de demostración. Las configuraciones de red, políticas de acceso y reglas de cortafuegos han sido simplificadas para facilitar la ejecución del workshop y **no cumplen con los estándares requeridos para entornos de producción**.