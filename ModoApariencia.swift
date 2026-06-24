import SwiftUI

// Quita : String, añade Identifiable
enum ModoApariencia: CaseIterable, Identifiable {
    case sistema
    case claro
    case oscuro
    
    // Añade 'id' para cumplir con Identifiable
    var id: Self { self }

    // Propiedad 'name' que devuelve la llave de localización
    var name: LocalizedStringKey {
        switch self {
        case .sistema:
            return "appearance.system" // Llave para "Sistema" / "System"
        case .claro:
            return "appearance.light" // Llave para "Claro" / "Light"
        case .oscuro:
            return "appearance.dark" // Llave para "Oscuro" / "Dark"
        }
    }
    
    // Tu lógica de colorScheme se queda igual
    var colorScheme: ColorScheme? {
        switch self {
        case .sistema:
            return nil
        case .claro:
            return .light
        case .oscuro:
            return .dark
        }
    }
}
