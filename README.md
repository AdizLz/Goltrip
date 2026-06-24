# WorldCup FIFA 2026 App

App móvil en SwiftUI para fanáticos del Mundial FIFA 2026, enfocada en Monterrey como ciudad sede. Incluye información de partidos, guía turística, exploración de estadio, tabla de posiciones en vivo y un bot de ayuda local

---

## Requisitos

- Xcode 15 o superior
- iOS 17+
- Cuenta en API-Sports para datos de jugadores y tabla
- Cuenta en Eventbrite para eventos

---

## Configuración de API Keys

1. Copia el archivo de ejemplo:
   ```
   cp worldcup/Secrets.plist.example worldcup/Secrets.plist
   ```
2. Abre `Secrets.plist` y llena tus keys reales:
   - `API_SPORTS_KEY` → obtén en [api-sports.io](https://www.api-sports.io/)
   - `EVENTBRITE_TOKEN` → obtén en [eventbrite.com/platform/api](https://www.eventbrite.com/platform/api)

---

## Pantallas

| Pantalla                 | Descripción                                                                                                   |
| ------------------------ | ------------------------------------------------------------------------------------------------------------- |
| **Login**                | Selección de idioma (Español / English).                                                                      |
| **Selección de equipos** | El usuario selecciona sus equipos favoritos del torneo.                                                       |
| **Home**                 | Muestra próximos partidos, eventos y noticias relacionadas con las ciudades sede del Mundial FIFA 2026.       |
| **Cultura**              | Guía cultural y turística de Monterrey, incluyendo CONARTE, Parque Fundidora, Macroplaza y MARCO.             |
| **Estadio**              | Información del estadio, jugadores, alineaciones, tabla general y acceso al mapa interior 3D.                 |
| **Mapa**                 | Mapa turístico interactivo de Monterrey con restaurantes, museos, hoteles, parques y otros puntos de interés. |
| **FIFABot**              | Asistente virtual que responde preguntas frecuentes sobre Monterrey y el Mundial FIFA 2026.                   |

---

## Estructura
```text
worldcup/
│
├── worldcupApp.swift              # Entry point y flujo de onboarding
├── Config.swift                   # Lector de API Keys desde Secrets.plist
├── LoginView.swift                # Selector de idioma
├── SeleccionEquiposView.swift     # Selección de equipos favoritos
├── MainView.swift                 # Contenedor principal con TabBar
├── TabBar.swift                   # Barra de navegación personalizada
├── FIFA2026App.swift              # Pantalla Home
├── MapaView.swift                 # Mapa turístico de Monterrey
├── EstadioMapView.swift           # Mapa interior del estadio
├── EventbriteService.swift        # Integración con la API de Eventbrite
│
├── Dama/
│   ├── CultureView.swift
│   ├── ConarteView.swift
│   ├── FundiView.swift
│   └── MacroView.swift
│
└── Estadio/
    ├── EstadioView.swift
    ├── JugadoresView.swift        # Jugadores (API en vivo)
    ├── TablaGeneralView.swift     # Tabla de posiciones (API en vivo)
    ├── ChatView.swift             # FIFABot
    ├── Alineaciones.swift
    ├── Mapa3DView.swift           # Vista 3D con SceneKit
    └── StadiumDetailView.swift
```
---

## Idiomas soportados

🇲🇽 Español (es-419)
🇺🇸 English (en)

Los textos están en archivos Localizable.strings dentro de es-419.lproj/ y en.lproj/.

## Frameworks utilizados
- SwiftUI → Interfaz de usuario.
- MapKit → Mapas y geolocalización.
- SceneKit → Visualización 3D del estadio.
- UserNotifications → Notificaciones locales.
- WebKit → Contenido web embebido.
- UIKit → Integración con componentes nativos.
---
<img width="1506" height="833" alt="image" src="https://github.com/user-attachments/assets/ef3f191c-4404-4158-b6af-113ef349c9be" />
<img width="1481" height="862" alt="image" src="https://github.com/user-attachments/assets/714e723a-1d4c-4595-8afe-e28bc2fe7cf1" />


## 👩‍💻 Autoras

Desarrollado por Asenet L, Melannie Lores, Damaris B y Linda De La Garza · Octubre 2025 

