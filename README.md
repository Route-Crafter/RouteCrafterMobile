# 🚌 Route Crafter

**Route Crafter** es una app colaborativa que permite a los usuarios **digitalizar recorridos de buses** en zonas donde esta información no está disponible en línea.

Con esta herramienta, cualquier persona puede subirse a un bus, iniciar un recorrido desde la app, y automáticamente se irá registrando su trayecto en tiempo real mediante geolocalización en segundo plano. Al bajarse, finaliza el recorrido y los datos se envían al servidor.

Es entendible que un usuario no realiza la totalidad del recorrido de una ruta de bus. Así que, lo interesante es que **los recorridos se construyen en comunidad**:  

- Un usuario puede registrar solo una parte del trayecto (ej. del punto A al C).  
- Otro puede hacer otro tramo del mismo bus (ej. del punto B al D).  
- El sistema combina todos los aportes para reconstruir una aproximación del recorrido completo de la ruta de bus.

Esta app es especialmente útil en **ciudades, pueblos o municipios donde todos o algunos de los recorridos del transporte público no están disponibles en internet**, permitiendo construir mapas colaborativos de transporte en tiempo real.

> 🚍 Porque nadie conoce mejor el transporte de una comunidad que quienes lo usan todos los días.

---

## 🚀 Características principales

- 📍 Registro de recorridos de bus mediante geolocalización en tiempo real.
- 🤝 Construcción colaborativa de rutas: múltiples usuarios aportan diferentes tramos.
- ☁️ Envío automático del recorrido al servidor al finalizar.
- 🗺️ Visualización del trayecto hecho por el usuario.

---

## 🔜 Próximamente

- 🔐 **Inicio de sesión de usuarios**: para que cada persona pueda visualizar y gestionar sus propios recorridos guardados.
- 🔄 **Registro de puntos de desvío**: permite marcar desvíos temporales de la ruta principal, como cuando el conductor modifica el trayecto para tomar un atajo con aprobación de los pasajeros.
- 🅿️ **Registro de puntos de parqueo temporal**: identifica lugares donde los buses suelen detenerse por un tiempo determinado para esperar a más pasajeros antes de continuar.

---

## 📦 Descargar e Instalar

Puedes descargar la última versión de la app desde el siguiente enlace:

👉 [Descargar APK](https://github.com/Route-Crafter/RouteCrafterMobile/raw/main/apk/route-crafter-v1.0.apk)

> ⚠️ Asegúrate de habilitar la instalación de apps desde fuentes desconocidas en tu dispositivo Android.

Pasos para instalar:

1. Descargar el archivo `.apk` desde el enlace de arriba.
2. Abrir el archivo en tu teléfono.
3. Confirmar la instalación.
4. ¡Listo! Ya puedes usar la app.

---

## 🖼️ Capturas de pantalla (opcional)

| Pantalla de Inicio | Función principal |
|--------------------|------------------|
| ![Inicio](./screenshots/inicio.png) | ![Función](./screenshots/funcion.png) |

---

## 🛠️ Tecnologías utilizadas

- Flutter
- Node.js (para el backend)

---

## 📡 Backend

Esta app se conecta con un backend en Node.js. Puedes encontrar el código aquí:

🔗 [Repositorio del Backend](https://github.com/Route-Crafter/RouteCrafterServer)

---

## 🙋‍♂️ Contribuir

Si quieres colaborar, ¡eres bienvenido! Por favor, abre un issue o haz un pull request.

---

## 📄 Licencia

Este proyecto está bajo la licencia Apache 2.0.
