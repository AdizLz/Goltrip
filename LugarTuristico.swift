import Foundation
import MapKit // Import MapKit because we need CLLocationCoordinate2D

// This struct is the "blueprint" for a single tourist spot.
struct LugarTuristico: Identifiable {
    // A unique ID required by SwiftUI to identify each item in a list or map.
    let id = UUID()
    
    // The name that will be displayed, e.g., "FIFA Fan Zone".
    let nombre: String
    
    // A category for the spot, e.g., "Fan Zone", "Evento", "Restaurante".
    let tipo: String
    
    // The exact location on the map using latitude and longitude.
    let coordenada: CLLocationCoordinate2D
    
    // The budget level for filtering. We use an Enum for predefined options.
    let presupuesto: Presupuesto

    // An Enum defines a group of related values, making your code safer and clearer.
    // It's also CaseIterable so we can loop through all cases for the filter.
    enum Presupuesto: String, CaseIterable, Identifiable {
        case bajo = " "
        //case medio = " "
        //case alto = " "
        
        // SwiftUI needs this to identify each enum case in the Picker.
        var id: String { self.rawValue }
    }
}
