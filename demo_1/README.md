# Guía de Despliegue de Servidores Web en AWS y GCP

## 1. Amazon Web Services (AWS)

### Método 1: Configuración Manual vía Consola

1. **Acceso al Servicio:** Inicie sesión en la consola de administración de AWS y navegue hasta el servicio **EC2**.
2. **Inicialización:** Haga clic en el botón **Launch Instance**.
3. **Parámetros Básicos:**
* **Name:** Ingrese un identificador, por ejemplo, `servidor-web-manual`.
* **Application and OS Images (AMI):** Seleccione la imagen oficial de **Ubuntu** (Ubuntu Server 22.04 LTS).
* **Instance Type:** Seleccione la clase `t3.micro` (o `t2.micro` según la disponibilidad de la cuenta).


4. **Configuración de Red (Network Settings):**
* Seleccione la opción **Create Security Group**.
* Marque la casilla **Allow SSH traffic** con origen `0.0.0.0/0`.
* Marque la casilla **Allow HTTP traffic from the internet** (`0.0.0.0/0`).


5. **Lanzamiento:** Haga clic en **Launch Instance**.
6. **Instalación de Nginx:**
* Una vez que la instancia pase al estado *Running*, conéctese mediante **EC2 Instance Connect** o cliente SSH.
* Ejecute los siguientes comandos en la terminal de la instancia:
```bash
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl enable --now nginx

```




7. **Verificación:** Copie la **Public IPv4 address** asignada a la máquina y páguela en la barra de direcciones de su navegador web.

---

### Método 2: Automatización con User Data

1. Ejecute los pasos 1 al 4 descritos en el **Método 1**.
2. Antes de lanzar la instancia, despliegue el panel **Advanced Details** ubicado al final del formulario.
3. Busque el campo de texto **User Data** e ingrese la instrucción de automatización Bash:
```bash
#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable --now nginx

```


4. Haga clic en **Launch Instance**. El hipervisor ejecutará el script con privilegios de superusuario durante el primer arranque, entregando la máquina con el servicio Nginx configurado y en ejecución.

---

## 2. Google Cloud Platform (GCP)

### Método 1: Configuración Manual vía Consola

1. **Acceso al Servicio:** Inicie sesión en la consola de Google Cloud y navegue a **Compute Engine** > **VM Instances**.
2. **Inicialización:** Haga clic en **Create Instance**.
3. **Parámetros Básicos:**
* **Name:** Ingrese `servidor-web-manual`.
* **Region / Zone:** Seleccione la región más cercana disponible.
* **Machine Configuration:** Seleccione la serie **E2** y el tipo de máquina `e2-micro`.
* **Boot Disk:** Asegúrese de seleccionar la imagen predeterminada de Debian o Ubuntu Server.


4. **Reglas de Cortafuegos (Firewall):**
* En la sección **Firewall**, marque la casilla **Allow HTTP traffic**.


5. **Lanzamiento:** Haga clic en el botón **Create**.
6. **Instalación de Nginx:**
* En el listado de instancias, haga clic en el botón **SSH** junto a la máquina virtual recién creada para abrir la consola del navegador.
* Ejecute los siguientes comandos:
```bash
sudo apt-get update -y
sudo apt-get install -y nginx

```




7. **Verificación:** En la consola de GCP, haga clic sobre el enlace hipertextual correspondiente a la **External IP** asignada a la instancia.

---

### Método 2: Automatización con Startup Script

1. Ejecute los pasos 1 al 4 del **Método 1**.
2. Despliegue el menú desplegable **Advanced options** al final de la página y seleccione la pestaña **Management**.
3. En la sección **Automation**, ubique el campo de texto **Startup script** e ingrese la secuencia de comandos:
```bash
#!/bin/bash
apt-get update -y
apt-get install -y nginx

```


4. Haga clic en **Create**. GCP asociará las instrucciones como metadatos de la instancia (`startup-script`) y las ejecutará automáticamente en el proceso de provisión.