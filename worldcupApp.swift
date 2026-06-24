import SwiftUI
import UserNotifications

@main
struct worldcupApp: App {
    
    // 1. Control del idioma
    @AppStorage("selectedLanguageIdentifier") var languageIdentifier: String = ""
    
    // 2. NUEVO: Controla si se hizo clic en CONTINUAR después de seleccionar el idioma.
    @AppStorage("hasCompletedLanguageSelection") var hasCompletedLanguageSelection: Bool = false
    
    // 3. hasCompletedSetup: Controla si el usuario ha completado toda la configuración inicial (Idioma Y Equipos).
    @AppStorage("hasCompletedSetup") var hasCompletedSetup: Bool = false

    // 4. Propiedad que convierte el String ("es") al Locale
    var currentLocale: Locale {
        return Locale(identifier: languageIdentifier.isEmpty ? "es" : languageIdentifier)
    }
    
    // 5. Delegado de Notificaciones
    private let notificationDelegate = AppNotificationDelegate()
    init() {
        if NSClassFromString("XCTestCase") == nil {
            UNUserNotificationCenter.current().delegate = notificationDelegate
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                // Etapa 3: App principal (Si el setup COMPLETO está hecho)
                if hasCompletedSetup {
                    MainView(selectedLanguageIdentifier: $languageIdentifier)
                
                // Etapa 2: Selección de Equipos
                // Se ejecuta si: 1) El idioma fue seleccionado (hasCompletedLanguageSelection = true) Y 2) El setup NO está completo.
                } else if hasCompletedLanguageSelection {
                    SeleccionEquiposView(
                        selectedLanguageIdentifier: $languageIdentifier,
                        // Pasamos el Binding $hasCompletedSetup, que SeleccionEquiposView modificará a TRUE al terminar.
                        hasCompletedLogin: $hasCompletedSetup
                    )
                
                // Etapa 1: Login
                // Se ejecuta si la selección de idioma NO ha sido confirmada.
                } else {
                    LoginView(
                        selectedLanguageIdentifier: $languageIdentifier,
                        // Pasamos el Binding $hasCompletedLanguageSelection para que el botón 'Continuar'
                        // lo cambie a TRUE y fuerce la transición a SeleccionEquiposView.
                        hasCompletedLogin: $hasCompletedLanguageSelection
                    )
                }
            }
            // Aplica el locale a la vista generada por el bloque condicional.
            .environment(\.locale, currentLocale)
        }
    }
}

class AppNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}
