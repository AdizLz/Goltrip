import SwiftUI

// Quita : String, añade Identifiable
enum Language: CaseIterable, Identifiable {
    case espanol
    case english
    
    // Añade 'id' para cumplir con Identifiable
    var id: Self { self }

    // Propiedad 'name' que devuelve la llave de localización
    var name: LocalizedStringKey {
        switch self {
        case .espanol:
            return "language.spanish" // Llave para "Español" / "Spanish"
        case .english:
            return "language.english" // Llave para "Inglés" / "English"
        }
    }

    // Tu lógica de 'identifier' y 'locale' se queda igual
    var identifier: String {
        switch self {
        case .espanol: return "es"
        case .english: return "en"
        }
    }
    
    var locale: Locale {
        return Locale(identifier: self.identifier)
    }
}
