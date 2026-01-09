<<<<<<< HEAD
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
=======
# RouteCrafter – Mobile App

Aplicación móvil de **RouteCrafter**, desarrollada en **Flutter**, que permite a los usuarios registrar recorridos reales de rutas de buses utilizando geolocalización en tiempo real y en segundo plano.

La app actúa como el punto de captura de datos del sistema, enviando recorridos al backend para su posterior análisis y unificación.

---

## 📱 Descripción general

RouteCrafter Mobile permite a los usuarios:

- Visualizar rutas de buses según su ubicación actual
- Registrar recorridos reales mientras se desplazan en un bus
- Contribuir a la digitalización comunitaria del transporte público
- Consultar recorridos previamente registrados para una ruta específica

---

## 📍 Funcionamiento general

Al iniciar la aplicación:

1. La app obtiene la **geolocalización actual del usuario**.
2. El usuario es ubicado automáticamente en el mapa.
3. A partir de la ubicación, la app determina:
   - País
   - Departamento / Estado
   - Ciudad
4. Con esta información, la app solicita al backend la **lista de rutas disponibles en esa ciudad**.

### Actualización dinámica por ubicación

- A medida que el usuario se mueve en el mapa:
  - Si cambia de ciudad, la app detecta el cambio.
  - Se actualiza automáticamente la lista de rutas visibles.
- El contenido siempre corresponde a la **ciudad actual del usuario**.

---

## 🚌 Registro de recorridos

El usuario puede iniciar un nuevo recorrido en cualquier momento.

### Selección de ruta

Al iniciar un recorrido, el usuario puede:

- Seleccionar una ruta existente de la ciudad actual
- Agregar una ruta existente de otra ciudad
- Crear una nueva ruta si no existe
- (Opcional) Ingresar la placa del vehículo

### Seguimiento del recorrido

Una vez iniciado el recorrido:

- La app registra periódicamente:
  - Latitud
  - Longitud
  - Velocidad
- Los puntos de geolocalización se:
  - Dibujan progresivamente en el mapa
  - Representan mediante un marcador con forma de bus
  - El marcador rota según la dirección del movimiento
- El recorrido continúa incluso si la app se encuentra **minimizada** (geolocalización en segundo plano).

### Finalización del recorrido

- Al finalizar el recorrido:
  - Se envía al backend la lista completa de geolocalizaciones registradas
  - El recorrido queda almacenado como una ejecución asociada a la ruta

---

## 🗺️ Visualización de recorridos

- El usuario puede seleccionar una ruta específica.
- En el mapa se muestran **todos los recorridos registrados** para esa ruta.
- Cada recorrido representa una ejecución independiente realizada por usuarios.

---

## 🔌 APIs utilizadas

La app consume exclusivamente las siguientes APIs del backend:

### Consultas (GET)

- Obtener países
- Obtener estados por país
- Obtener ciudades por estado
- Obtener rutas por ciudad
- Obtener rutas con filtros:
  - `countryIso`
  - `stateName`
  - `cityName`
- Obtener recorridos por ruta

### Creación (POST)

- Crear país
- Crear estado
- Crear ciudad
- Crear ruta
- Crear recorrido (`routeExecution`)

### Actualización (PATCH)

- Finalizar recorrido (`routeExecution`)

---

## 🛠️ Tecnologías

- **Flutter** (Android & iOS)
- **Dart**
- **Google Maps**
- **Geolocalización en tiempo real**
- **Geolocalización en segundo plano**
- **APIs REST**

---

## 🏗️ Características técnicas destacadas

- Detección automática de país, estado y ciudad por ubicación
- Actualización dinámica de rutas según la ciudad actual
- Registro de recorridos en segundo plano
- Renderizado progresivo del recorrido en el mapa
- Comunicación directa con backend REST
- Soporte multiplataforma (Android / iOS)

---

## 🚧 Estado actual

Funcionalidades disponibles:

- ✅ Geolocalización y visualización en mapa
- ✅ Obtención dinámica de rutas por ciudad
- ✅ Creación y registro de recorridos
- ✅ Visualización de recorridos por ruta
- ✅ Registro en segundo plano

Funcionalidades en desarrollo / futuras:

- 🔜 Visualización de rutas unificadas
- 🔜 Métricas de cobertura de ruta
- 🔜 Sistema de autenticación de usuarios
- 🔜 Mejoras en precisión y agregación de recorridos
>>>>>>> first_functional_version

---

## 📄 Licencia

<<<<<<< HEAD
Este proyecto está bajo la licencia Apache 2.0.
=======
Proyecto en desarrollo. Uso interno / privado.

---

**RouteCrafter Mobile**  
Capturando recorridos reales para digitalizar el transporte público.
>>>>>>> first_functional_version
