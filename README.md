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

---

## 📄 Licencia

Proyecto en desarrollo. Uso interno / privado.

---

**RouteCrafter Mobile**  
Capturando recorridos reales para digitalizar el transporte público.
