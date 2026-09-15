> **ADVERTENCIA IMPORTANTE DE SEGURIDAD**
> **ESTE ENTORNOS Y CÓDIGO DE DEMOSTRACIÓN NO SON APTOS PARA PRODUCCIÓN.**
> La arquitectura presentada ha sido diseñada exclusivamente con fines pedagógicos como una Prueba de Concepto (PoC) de Infraestructura como Código (IaC). Presenta omisiones de seguridad intencionales para facilitar la ejecución en clase, tales como:
> * Exposición pública directa de la base de datos PostgreSQL (`0.0.0.0/0`).
> * Reglas de Security Groups permisivas sin segmentación estricta de red por subredes privadas.
> * Falta de cifrado en reposo y en tránsito para recursos S3 y RDS.
> * Inexistencia de un balanceador de carga (ALB) y capa de HTTPS/TLS.
> 
> 
> **NO utilice este diseño ni sus archivos de configuración en entornos reales de producción.**

---

# Guía de Despliegue de Infraestructura con Terraform en AWS

## 1. Gestión de Autenticación y Credenciales en AWS CLI

### Paso 1.1: Inicio de Sesión

Si utiliza credenciales basadas en AWS SSO / AWS IAM Identity Center, inicie la sesión en su terminal:

```bash
aws sso login --profile default

```

---

### Paso 1.2: Exportación de Credenciales a la Terminal

Para que el proveedor de Terraform reconozca el token de sesión activo, exporte las credenciales a las variables de entorno de su sesión de consola actual:

* **En Linux / macOS:**
```bash
eval $(aws configure export-credentials --format env)

```


* **En Windows (PowerShell):**
```powershell
aws configure export-credentials --format env-powershell | Invoke-Expression

```



---

### Paso 1.3: Limpieza e Invalidación de Credenciales

En caso de que la sesión expire (obteniendo un error de `Credentials expired`), invalide las variables de entorno almacenadas en la memoria de la consola antes de solicitar un nuevo token:

* **En Linux / macOS:**
```bash
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

```


* **En Windows (PowerShell):**
```powershell
Remove-Item Env:\AWS_ACCESS_KEY_ID -ErrorAction SilentlyContinue
Remove-Item Env:\AWS_SECRET_ACCESS_KEY -ErrorAction SilentlyContinue
Remove-Item Env:\AWS_SESSION_TOKEN -ErrorAction SilentlyContinue

```



Una vez ejecutada la limpieza, repita el **Paso 1.1** y el **Paso 1.2**.

---

## 2. Despliegue de la Infraestructura como Código (IaC)

### Paso 2.1: Verificación de la Estructura de Archivos

Asegúrese de contar con la siguiente jerarquía dentro del directorio de trabajo `demo_aws_iac`:

```text
demo_aws_iac/
├── images/
│   └── mi_imagen.jpg
├── templates/
│   └── user_data.sh.tftpl
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── security.tf
├── s3.tf
├── rds.tf
└── ec2.tf

```

---

### Paso 2.2: Inicialización del Proyecto

Abra la terminal en el directorio del proyecto y descargue los proveedores declarados en `providers.tf`:

```bash
terraform init

```

---

### Paso 2.3: Validación del Plan de Ejecución

Genere una vista previa de los recursos que serán creados en la cuenta de AWS y verifique que no existan errores de sintaxis:

```bash
terraform plan

```

---

### Paso 2.4: Aprovisionamiento de Infraestructura

Ejecute el despliegue de los recursos. El proceso tomará entre 3 y 5 minutos mientras AWS aprovisiona la instancia de base de datos RDS PostgreSQL:

```bash
terraform apply -auto-approve

```

Al finalizar la ejecución, la terminal mostrará la sección `Outputs` con la dirección pública asignada:

```text
Outputs:

rds_endpoint = "demodb.c123456789.us-east-1.rds.amazonaws.com:5432"
s3_bucket_name = "demo-images-production-a1b2c3d4"
url_aplicacion = "http://54.210.10.15"

```

---

### Paso 2.5: Verificación del Servicio

1. Copie la dirección obtenida en la salida `url_aplicacion`.
2. Páguela en un navegador web.
3. Verifique el incremento del contador de registros almacenados en la base de datos PostgreSQL mediante recargas de la página, así como la correcta visualización del archivo alojado en Amazon S3.

---

### Paso 2.6: Destrucción Automatizada de Recursos

Para evitar cobros no planificados en la cuenta de AWS, elimine la totalidad de los recursos creados al finalizar la sesión:

```bash
terraform destroy -auto-approve

```