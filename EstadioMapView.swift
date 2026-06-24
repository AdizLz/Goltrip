//
//  EstadioMapView.swift
//  EstadioMapView
//
//  Created by Damaris B on 19/10/25.
//

import SwiftUI
import MapKit

// MARK: - Modelos de Datos
struct StadiumLocation: Identifiable {
    let id: String
    let name: String
    let category: LocationCategory
    let section: String
    let price: String?
    let view: String?
    let coordinate: CLLocationCoordinate2D
    let icon: String

    enum LocationCategory: String, CaseIterable {
        case seat = "Asientos"
        case restroom = "Baños"
        case food = "Comida"
        case restaurant = "Restaurantes"
        case store = "Tiendas"
        case accessibility = "Accesibilidad"
        case entrance = "Puertas"
        case parking = "Estacionamiento"
        
        var color: Color {
            switch self {
            case .seat: return .orange
            case .restroom: return .red
            case .food: return .yellow
            case .restaurant: return .orange
            case .store: return .green
            case .accessibility: return .purple
            case .entrance: return .gray
            case .parking: return Color(red: 0.5, green: 0.55, blue: 0.55)
            }
        }
        
        var emoji: String {
            switch self {
            case .seat: return "💺"
            case .restroom: return "🚻"
            case .food: return "🍔"
            case .restaurant: return "🍴"
            case .store: return "🛍️"
            case .accessibility: return "♿️"
            case .entrance: return "🚪"
            case .parking: return "🅿️"
            }
        }
    }
}

// MARK: - View Principal
struct EstadioMapView: View {
    @Binding var currentScreen: String
    @State private var searchText = ""
    @State private var selectedLocation: StadiumLocation?
    @State private var showingLocationDetail = false
    @State private var selectedCategory: StadiumLocation.LocationCategory?
    @State private var camera = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.669282467531197, longitude: -100.2444465605275),
            span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
        )
    )
    @State private var mapType: MKMapType = .standard
    @State private var zoomLevel: Double = 1.0
    
    // Coordenada central del Estadio BBVA
    let stadiumCenter = CLLocationCoordinate2D(latitude: 25.669282467531197, longitude: -100.2444465605275)
    
    var body: some View {
            ZStack(alignment: .top) { // 1. ZStack es el contenedor principal
                
                // --- CAPA 1: FONDO Y MAPA ---
                
                // Color de fondo (llena toda la pantalla)
                Color(red: 0.04, green: 0.06, blue: 0.1)
                    .ignoresSafeArea()
                
                // Mapa real (está en el fondo, detrás del UI)
                realMapView
                    .frame(maxHeight: .infinity) // El mapa llena todo el espacio
                    .ignoresSafeArea() // El mapa ignora la safe area para estar pantalla completa
                
                // --- CAPA 2: TU INTERFAZ (UI) ---
                
                // Este VStack contiene tu header, search, y el footer
                VStack(spacing: 0) {
                    // Header (con su propio fondo)
                    headerView
                        .padding(.top, 40) // <-- Padding MANUAL para salvar el notch/cámara
                        .background(Color(red: 0.04, green: 0.06, blue: 0.1)) // Fondo para el header
                    
                    // Barra de búsqueda (con su propio fondo)
                    searchBar
                        .background(Color(red: 0.04, green: 0.06, blue: 0.1)) // Fondo para la barra
                    
                    // Este Spacer ocupa todo el espacio del medio,
                    // permitiendo que se vea el mapa detrás.
                    Spacer()
                    
                    // Acceso rápido (se empuja al fondo)
                    quickAccessView
                        // El fondo ya está definido en la propia vista (0.08, 0.11, 0.17)
                        .padding(.bottom, 20) // <-- Padding MANUAL para salvar la barra de inicio
                }
                .ignoresSafeArea() // El VStack debe ignorar la safe area para pegarse a los bordes
                
            }
            .sheet(isPresented: $showingLocationDetail) {
                if let location = selectedLocation {
                    LocationDetailView(location: location)
                        // Hacemos el modal más pequeño y deslizable
                        .presentationDetents([.fraction(0.45), .medium])
                        .presentationDragIndicator(.visible)
                }
            }
            .foregroundColor(.white) // Aplica color de texto blanco a todo
        }
    
    // MARK: - Header
    var headerView: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 8) {
                        
                        // 1. Botón de Atrás
                        Button(action: {
                            currentScreen = "home"
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(4) // Pequeño padding para hacerlo más tocable
                        }
                        .buttonStyle(PlainButtonStyle()) // Asegura que no tenga estilo predeterminado
                        
                        // 2. Título al lado del botón
                        Text("Estadio BBVA Bancomer")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
            Text("Monterrey · Capacidad: 51,348")
                .font(.system(size: 15))
                .foregroundColor(Color(white: 0.55))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    // MARK: - Barra de búsqueda
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar asiento, zona, servicio...", text: $searchText)
                .foregroundColor(.white)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(15)
        .background(Color(red: 0.1, green: 0.14, blue: 0.2))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    // MARK: - Mapa Real
    var realMapView: some View {
        ZStack {
            Map(position: $camera, interactionModes: .zoom) {
                ForEach(filteredLocations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        LocationPin(location: location)
                            .onTapGesture {
                                selectedLocation = location
                                showingLocationDetail = true
                            }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .cornerRadius(20)
            .padding(20)
            
            // Controles de vista del mapa
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        // Botón de zoom in
                        Button(action: zoomIn) {
                            Image(systemName: "plus.magnifyingglass")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color(red: 0.1, green: 0.14, blue: 0.2))
                                .cornerRadius(8)
                        }
                        
                        // Botón de zoom out
                        Button(action: zoomOut) {
                            Image(systemName: "minus.magnifyingglass")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color(red: 0.1, green: 0.14, blue: 0.2))
                                .cornerRadius(8)
                        }
                        
                        Divider()
                            .frame(width: 30)
                            .background(Color.gray)
                        
                        // Botón de cambiar vista
                        Button(action: {
                            mapType = mapType == .standard ? .hybrid : .standard
                        }) {
                            Image(systemName: mapType == .standard ? "map" : "globe.americas.fill")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color(red: 0.1, green: 0.14, blue: 0.2))
                                .cornerRadius(8)
                        }
                        
                        // Botón de recentrar
                        Button(action: resetCamera) {
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color(red: 0.1, green: 0.14, blue: 0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Funciones de Zoom
    func zoomIn() {
        withAnimation {
            zoomLevel = min(zoomLevel * 0.5, 1.0)
            camera = .region(MKCoordinateRegion(
                center: stadiumCenter,
                span: MKCoordinateSpan(latitudeDelta: 0.004 * zoomLevel, longitudeDelta: 0.004 * zoomLevel)
            ))
        }
    }
    
    func zoomOut() {
        withAnimation {
            zoomLevel = max(zoomLevel * 2.0, 0.125)
            camera = .region(MKCoordinateRegion(
                center: stadiumCenter,
                span: MKCoordinateSpan(latitudeDelta: 0.004 * zoomLevel, longitudeDelta: 0.004 * zoomLevel)
            ))
        }
    }
    
    func resetCamera() {
        withAnimation {
            zoomLevel = 1.0
            camera = .region(MKCoordinateRegion(
                center: stadiumCenter,
                span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
            ))
        }
    }
    
    // MARK: - Acceso rápido
    var quickAccessView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Acceso Rápido")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(StadiumLocation.LocationCategory.allCases, id: \.self) { category in
                    QuickAccessButtons(category: category) {
                        selectedCategory = category
                        searchText = category.rawValue
                    }
                }
            }
        }
        .padding(20)
        .background(Color(red: 0.08, green: 0.11, blue: 0.17))
    }
    
    // Datos de ubicaciones
    var locations: [StadiumLocation] {
        StadiumDataManager.shared.getAllLocations()
    }
    
    var filteredLocations: [StadiumLocation] {
        if searchText.isEmpty {
            return locations
        }
        return locations.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.section.localizedCaseInsensitiveContains(searchText) ||
            $0.category.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Pin de Ubicación en Mapa
struct LocationPin: View {
    let location: StadiumLocation
    
    var body: some View {
        VStack(spacing: 0) {
            Text(location.icon)
                .font(.system(size: 20))
                .padding(6)
                .background(location.category.color)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(radius: 4)
            
            // Triángulo apuntando hacia abajo
            Triangle()
                .fill(location.category.color)
                .frame(width: 10, height: 6)
                .offset(y: -2)
        }
    }
}

// MARK: - Triángulo para el pin
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Botón de Acceso Rápido
struct QuickAccessButtons: View {
    let category: StadiumLocation.LocationCategory
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(category.emoji)
                    .font(.system(size: 32))
                
                Text(category.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color(red: 0.1, green: 0.14, blue: 0.2))
            .cornerRadius(12)
        }
    }
}

// MARK: - Vista de Detalle de Ubicación
struct LocationDetailView: View {
    let location: StadiumLocation
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.1, green: 0.14, blue: 0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Icono
                    Text(location.icon)
                        .font(.system(size: 60))
                        .padding()
                        .background(location.category.color.opacity(0.2))
                        .clipShape(Circle())
                    
                    // Título
                    VStack(spacing: 5) {
                        Text(location.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(location.section)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    // Información
                    VStack(spacing: 15) {
                        if let price = location.price {
                            InfoRow(label: "Precio aproximado", value: price)
                        }
                        
                        if let view = location.view {
                            InfoRow(label: "Vista", value: view)
                        }
                        
                        InfoRow(label: "Categoría", value: location.category.rawValue)
                    }
                    .padding()
                    .background(Color(red: 0.04, green: 0.06, blue: 0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    // Botones de acción
                    HStack(spacing: 15) {
                        Button(action: { dismiss() }) {
                            Text("Cerrar")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(white: 0.2))
                                .cornerRadius(12)
                        }
                        
                        Button(action: openInMaps) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Ir con Maps")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    func openInMaps() {
        let coordinate = location.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = location.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

// MARK: - Fila de Información
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Manager de Datos
class StadiumDataManager {
    static let shared = StadiumDataManager()
    
    private init() {}
    
    func getAllLocations() -> [StadiumLocation] {
        return [
            // Asientos Nivel 100 - Zona Norte
            StadiumLocation(
                id: "sec-117",
                name: "Sección 117",
                category: .seat,
                section: "Preferente 117",
                price: "$2,500",
                view: "Vista frontal central",
                coordinate: CLLocationCoordinate2D(latitude: 25.670082467531197, longitude: -100.2444465605275),
                icon: "💺"
            ),
            StadiumLocation(
                id: "sec-115",
                name: "Sección 115",
                category: .seat,
                section: "Preferente 115",
                price: "$2,400",
                view: "Vista frontal",
                coordinate: CLLocationCoordinate2D(latitude: 25.670082467531197, longitude: -100.2447465605275),
                icon: "💺"
            ),
            StadiumLocation(
                id: "sec-119",
                name: "Sección 119",
                category: .seat,
                section: "Preferente 119",
                price: "$2,400",
                view: "Vista frontal",
                coordinate: CLLocationCoordinate2D(latitude: 25.670082467531197, longitude: -100.2441465605275),
                icon: "💺"
            ),
            
            // Asientos - Zonas laterales
            StadiumLocation(
                id: "sec-103",
                name: "Sección 103",
                category: .seat,
                section: "Lateral 103",
                price: "$1,800",
                view: "Vista lateral",
                coordinate: CLLocationCoordinate2D(latitude: 25.669282467531197, longitude: -100.2449465605275),
                icon: "💺"
            ),
            StadiumLocation(
                id: "sec-129",
                name: "Sección 129",
                category: .seat,
                section: "Lateral 129",
                price: "$1,800",
                view: "Vista lateral",
                coordinate: CLLocationCoordinate2D(latitude: 25.669282467531197, longitude: -100.2439465605275),
                icon: "💺"
            ),
            
            // Baños
            StadiumLocation(
                id: "bano-1",
                name: "Baños Norte Este",
                category: .restroom,
                section: "Nivel 1",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.669982467531197, longitude: -100.2441465605275),
                icon: "🚻"
            ),
            StadiumLocation(
                id: "bano-2",
                name: "Baños Norte Oeste",
                category: .restroom,
                section: "Nivel 1",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.669982467531197, longitude: -100.2447465605275),
                icon: "🚻"
            ),
            StadiumLocation(
                id: "bano-3",
                name: "Baños Sur",
                category: .restroom,
                section: "Nivel 1",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.668582467531197, longitude: -100.2444465605275),
                icon: "🚻"
            ),
            
            // Comida
            StadiumLocation(
                id: "food-1",
                name: "Snack Bar Norte",
                category: .food,
                section: "Concourse Norte",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.670182467531197, longitude: -100.2444465605275),
                icon: "🍔"
            ),
            StadiumLocation(
                id: "food-2",
                name: "Snack Bar Este",
                category: .food,
                section: "Concourse Este",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.669282467531197, longitude: -100.2437465605275),
                icon: "🍔"
            ),
            
            // Restaurantes
            StadiumLocation(
                id: "rest-1",
                name: "Restaurante Azul",
                category: .restaurant,
                section: "Nivel concourse",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.668682467531197, longitude: -100.2445465605275),
                icon: "🍴"
            ),
            StadiumLocation(
                id: "rest-2",
                name: "Restaurante VIP",
                category: .restaurant,
                section: "Nivel Premium",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.669882467531197, longitude: -100.2448465605275),
                icon: "🍴"
            ),
            
            // Tiendas
            StadiumLocation(
                id: "tienda-1",
                name: "Tienda Oficial Rayados",
                category: .store,
                section: "Entrada principal",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.668382467531197, longitude: -100.2444465605275),
                icon: "🛍️"
            ),
            StadiumLocation(
                id: "tienda-2",
                name: "Fan Shop",
                category: .store,
                section: "Concourse Norte",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.670182467531197, longitude: -100.2442465605275),
                icon: "🛍️"
            ),
            
            // Accesibilidad
            StadiumLocation(
                id: "disc-1",
                name: "Acceso Discapacitados Norte",
                category: .accessibility,
                section: "Zona Norte Este",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.669982467531197, longitude: -100.2440465605275),
                icon: "♿️"
            ),
            StadiumLocation(
                id: "disc-2",
                name: "Acceso Discapacitados Sur",
                category: .accessibility,
                section: "Zona Sur",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.668582467531197, longitude: -100.2443465605275),
                icon: "♿️"
            ),
            
            // Puertas
            StadiumLocation(
                id: "puerta-1",
                name: "Puerta Principal P1",
                category: .entrance,
                section: "Acceso Sur",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.668282467531197, longitude: -100.2444465605275),
                icon: "🚪"
            ),
            StadiumLocation(
                id: "puerta-2",
                name: "Puerta Norte P2",
                category: .entrance,
                section: "Acceso Norte",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.670282467531197, longitude: -100.2444465605275),
                icon: "🚪"
            ),
            StadiumLocation(
                id: "puerta-3",
                name: "Puerta Este P3",
                category: .entrance,
                section: "Acceso Este",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.669282467531197, longitude: -100.2436465605275),
                icon: "🚪"
            ),
            
            // Estacionamiento
            StadiumLocation(
                id: "parking-1",
                name: "Estacionamiento E1",
                category: .parking,
                section: "Zona Noroeste",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.670282467531197, longitude: -100.2451465605275),
                icon: "🅿️"
            ),
            StadiumLocation(
                id: "parking-2",
                name: "Estacionamiento E2",
                category: .parking,
                section: "Zona Sureste",
                price: nil,
                view: nil,
                coordinate: CLLocationCoordinate2D(latitude: 25.668282467531197, longitude: -100.2437465605275),
                icon: "🅿️"
            )
        ]
    }
}

// MARK: - Preview
struct EstadioMapView_Previews: PreviewProvider {
    static var previews: some View {
        EstadioMapView(currentScreen: .constant("home"))
    }
}
