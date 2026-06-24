# WorldCup FIFA 2026 App

App iOS en SwiftUI para el Mundial FIFA 2026 — sede Monterrey.

## Configuración de API Keys

1. Copia el archivo de ejemplo:
   ```
   cp worldcup/Secrets.plist.example worldcup/Secrets.plist
   ```
2. Abre `Secrets.plist` y llena tus keys reales:
   - `API_SPORTS_KEY` → obtén en [api-sports.io](https://www.api-sports.io/)
   - `EVENTBRITE_TOKEN` → obtén en [eventbrite.com/platform/api](https://www.eventbrite.com/platform/api)

3. **Importante:** `Secrets.plist` está en `.gitignore` y nunca se subirá a Git.

## Estructura
- `LoginView` → Selector de idioma (ES/EN)
- `SeleccionEquiposView` → Equipos favoritos
- `MainView` → TabBar principal (Home, Cultura, Estadio, Mapa, FIFABot)
