import SwiftUI

struct MainView: View {
    
    @Binding var selectedLanguageIdentifier: String    
    // Estados para controlar la navegación
    @State private var activeTab: String = "home"
    @State private var currentScreen: String = "home"
    @State private var modoApariencia: ModoApariencia = .oscuro

    var body: some View {
        ZStack {
            // Fondo principal
            Color.theme.mainBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Contenido de la pantalla activa
                Group {
                    switch currentScreen {
                    case "home":
                        FIFA2026App(selectedLanguageIdentifier: $selectedLanguageIdentifier)
                    case "cultural":
                        CultureView(selectedLanguageIdentifier: $selectedLanguageIdentifier, modoApariencia: $modoApariencia)
                    case "stadium":
                        EstadioView()
                    case "map":
                        MapaView()
                    case "fifabot":
                        ChatBotView()
                    default:
                        FIFA2026App(selectedLanguageIdentifier: $selectedLanguageIdentifier)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Barra de navegación inferior personalizada
                BottomTabBar(activeTab: $activeTab, currentScreen: $currentScreen)
            }
        }
        .ignoresSafeArea(.keyboard) // Para que el teclado no afecte el layout
    }
}
