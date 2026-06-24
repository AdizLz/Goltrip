import SwiftUI
import MapKit
import Contacts

// MARK: - Modelos
struct LugarInteres: Identifiable {
    let id = UUID()
    let nombre: String
    let tipo: TipoLugar
    let coordenada: CLLocationCoordinate2D
    let distancia: Int // en metros desde el centro
    let direccion: String
}

enum TipoLugar: String, CaseIterable {
    case restaurante = "Restaurantes"
    case museo = "Museos"
    case parque = "Parques"
    case hotel = "Hoteles"
    case bar = "Bares"
    case banco = "Bancos"
    
    var icono: String {
        switch self {
        case .restaurante: return "fork.knife"
        case .museo: return "building.columns"
        case .parque: return "tree.fill"
        case .hotel: return "bed.double.fill"
        case .bar: return "wineglass.fill"
        case .banco: return "banknote.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .restaurante: return Color(red: 0.98, green: 0.45, blue: 0.33)
        case .museo: return Color(red: 0.60, green: 0.40, blue: 0.90)
        case .parque: return Color(red: 0.30, green: 0.85, blue: 0.55)
        case .hotel: return Color(red: 0.20, green: 0.70, blue: 0.95)
        case .bar: return Color(red: 0.95, green: 0.65, blue: 0.25)
        case .banco: return Color(red: 0.40, green: 0.75, blue: 0.85)
        }
    }
}

// MARK: - Vista Principal
struct MapaView: View {
    // Centro de Monterrey (aproximado entre Macroplaza y Fundidora)
    private let centroMonterrey = CLLocationCoordinate2D(
        latitude: 25.6866,
        longitude: -100.3161
    )
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var tipoSeleccionado: TipoLugar? = nil
    
    // Lugares distribuidos por diferentes zonas de Monterrey
    let lugares: [LugarInteres] = [
        // Restaurantes en diferentes zonas
        .init(nombre: "Pangea", tipo: .restaurante, coordenada: .init(latitude: 25.6580, longitude: -100.3501), distancia: 3800, direccion: "Lázaro Cárdenas 2400, Residencial San Agustín, San Pedro Garza García, N.L."),
        .init(nombre: "Taquería Orinoco", tipo: .restaurante, coordenada: .init(latitude: 25.6754, longitude: -100.3089), distancia: 1500, direccion: "Dr. Coss 1014, Centro, Monterrey, N.L."),
        .init(nombre: "La Nacional", tipo: .restaurante, coordenada: .init(latitude: 25.6715, longitude: -100.3095), distancia: 2000, direccion: "Av. Constitución 300, Centro, Monterrey, N.L."),
        .init(nombre: "Los Arcos", tipo: .restaurante, coordenada: .init(latitude: 25.6512, longitude: -100.2889), distancia: 5200, direccion: "Av. San Jerónimo 1000, San Jerónimo, Monterrey, N.L."),
        .init(nombre: "El Rey del Cabrito", tipo: .restaurante, coordenada: .init(latitude: 25.6923, longitude: -100.3345), distancia: 2100, direccion: "Av. Constitución 817, Centro, Monterrey, N.L."),
        .init(nombre: "Mochomos San Pedro", tipo: .restaurante, coordenada: .init(latitude: 25.6537, longitude: -100.3589), distancia: 4500, direccion: "Av. José Vasconcelos 402, Del Valle, San Pedro Garza García, N.L."),
        
        // Museos
        .init(nombre: "MARCO", tipo: .museo, coordenada: .init(latitude: 25.6698, longitude: -100.3101), distancia: 2200, direccion: "Zuazua y Jardón s/n, Centro, Monterrey, N.L."),
        .init(nombre: "Museo del Acero", tipo: .museo, coordenada: .init(latitude: 25.6785, longitude: -100.2834), distancia: 3500, direccion: "Av. Fundidora s/n, Parque Fundidora, Monterrey, N.L."),
        .init(nombre: "Museo de Historia Mexicana", tipo: .museo, coordenada: .init(latitude: 25.6692, longitude: -100.3086), distancia: 2300, direccion: "Dr. Coss 445, Centro, Monterrey, N.L."),
        .init(nombre: "Planetario Alfa", tipo: .museo, coordenada: .init(latitude: 25.6541, longitude: -100.2678), distancia: 6000, direccion: "Av. Roberto Garza Sada 1000, Carrizalejo, San Pedro Garza García, N.L."),
        
        // Parques
        .init(nombre: "Parque Fundidora", tipo: .parque, coordenada: .init(latitude: 25.6785, longitude: -100.2834), distancia: 3500, direccion: "Av. Fundidora s/n, Obrera, Monterrey, N.L."),
        .init(nombre: "Parque Ecológico Chipinque", tipo: .parque, coordenada: .init(latitude: 25.6123, longitude: -100.3589), distancia: 9500, direccion: "Carretera a Chipinque Km 2.5, San Pedro Garza García, N.L."),
        .init(nombre: "Macroplaza", tipo: .parque, coordenada: .init(latitude: 25.6692, longitude: -100.3095), distancia: 2100, direccion: "Av. Zuazua, Centro de Monterrey, Monterrey, N.L."),
        .init(nombre: "Parque La Huasteca", tipo: .parque, coordenada: .init(latitude: 25.6245, longitude: -100.4512), distancia: 14000, direccion: "Carretera a La Huasteca, Santa Catarina, N.L."),
        .init(nombre: "Paseo Santa Lucía", tipo: .parque, coordenada: .init(latitude: 25.6723, longitude: -100.3056), distancia: 1800, direccion: "Padre Mier, Centro, Monterrey, N.L."),
        
        // Hoteles
        .init(nombre: "Hotel Fiesta Americana", tipo: .hotel, coordenada: .init(latitude: 25.6698, longitude: -100.3120), distancia: 2000, direccion: "Av. Constitución 444 Ote, Centro, Monterrey, N.L."),
        .init(nombre: "Safi Royal Luxury Valle", tipo: .hotel, coordenada: .init(latitude: 25.6534, longitude: -100.3534), distancia: 4200, direccion: "Lázaro Cárdenas 2305, Del Valle, San Pedro Garza García, N.L."),
        .init(nombre: "Quinta Real Monterrey", tipo: .hotel, coordenada: .init(latitude: 25.6589, longitude: -100.3456), distancia: 3600, direccion: "Diego Rivera 500, Valle Oriente, San Pedro Garza García, N.L."),
        .init(nombre: "City Express Monterrey", tipo: .hotel, coordenada: .init(latitude: 25.6710, longitude: -100.3130), distancia: 1900, direccion: "Pino Suárez 444, Centro, Monterrey, N.L."),
        .init(nombre: "Camino Real Monterrey", tipo: .hotel, coordenada: .init(latitude: 25.6523, longitude: -100.3589), distancia: 4600, direccion: "Av. San Jerónimo 1000, San Jerónimo, Monterrey, N.L."),
        
        // Bares
        .init(nombre: "Bar La Tumba", tipo: .bar, coordenada: .init(latitude: 25.6708, longitude: -100.3118), distancia: 2000, direccion: "Matamoros 1502, Centro, Monterrey, N.L."),
        .init(nombre: "El Barril", tipo: .bar, coordenada: .init(latitude: 25.6700, longitude: -100.3110), distancia: 2100, direccion: "Morelos 1020, Centro, Monterrey, N.L."),
        .init(nombre: "Simon's Tavern", tipo: .bar, coordenada: .init(latitude: 25.6645, longitude: -100.3045), distancia: 2800, direccion: "Padre Mier 909, Centro, Monterrey, N.L."),
        .init(nombre: "The Brick", tipo: .bar, coordenada: .init(latitude: 25.6534, longitude: -100.3512), distancia: 4300, direccion: "Calzada del Valle 255, Del Valle, San Pedro Garza García, N.L."),
        .init(nombre: "Luna Rooftop", tipo: .bar, coordenada: .init(latitude: 25.6689, longitude: -100.3089), distancia: 2200, direccion: "Padre Mier 194 Pte, Centro, Monterrey, N.L."),
        
        // Bancos
        .init(nombre: "BBVA Constitución", tipo: .banco, coordenada: .init(latitude: 25.6712, longitude: -100.3138), distancia: 1850, direccion: "Av. Constitución 325, Centro, Monterrey, N.L."),
        .init(nombre: "Banorte Centro", tipo: .banco, coordenada: .init(latitude: 25.6703, longitude: -100.3128), distancia: 1950, direccion: "Hidalgo 325, Centro, Monterrey, N.L."),
        .init(nombre: "Santander San Pedro", tipo: .banco, coordenada: .init(latitude: 25.6545, longitude: -100.3545), distancia: 4400, direccion: "Av. Vasconcelos 150, Del Valle, San Pedro Garza García, N.L."),
        .init(nombre: "Citibanamex Valle", tipo: .banco, coordenada: .init(latitude: 25.6556, longitude: -100.3478), distancia: 3900, direccion: "Av. Lázaro Cárdenas 1000, Valle Oriente, San Pedro Garza García, N.L."),
        .init(nombre: "HSBC Fundidora", tipo: .banco, coordenada: .init(latitude: 25.6778, longitude: -100.2912), distancia: 3200, direccion: "Av. Fundidora 501, Obrera, Monterrey, N.L.")
    ]
    
    var lugaresFiltrados: [LugarInteres] {
        if let tipo = tipoSeleccionado {
            return lugares.filter { $0.tipo == tipo }.sorted { $0.distancia < $1.distancia }
        }
        return lugares.sorted { $0.distancia < $1.distancia }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView(
                tipoSeleccionado: $tipoSeleccionado
            )
            
            // MAPA contenido en un rectángulo
            Map(position: $cameraPosition) {
                // Marcador del centro de Monterrey
                Annotation("Centro de Monterrey", coordinate: centroMonterrey) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 30, height: 30)
                        Image(systemName: "location.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                }
                
                // Marcadores de lugares filtrados
                ForEach(lugaresFiltrados) { lugar in
                    Annotation(lugar.nombre, coordinate: lugar.coordenada) {
                        ZStack {
                            Circle()
                                .fill(lugar.tipo.color.opacity(0.8))
                                .frame(width: 40, height: 40)
                            Circle()
                                .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                                .frame(width: 32, height: 32)
                            Image(systemName: lugar.tipo.icono)
                                .foregroundColor(lugar.tipo.color)
                                .font(.system(size: 14, weight: .semibold))
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .frame(height: 350)
            .cornerRadius(16)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            // Lista de lugares
            ListaLugaresView(
                lugares: lugaresFiltrados
            )
        }
        .background(Color(red: 0.06, green: 0.09, blue: 0.16))
        .onAppear {
            cameraPosition = .camera(
                MapCamera(
                    centerCoordinate: centroMonterrey,
                    distance: 15000 // Vista más amplia de toda la ciudad
                )
            )
        }
    }
}

// MARK: - Header
struct HeaderView: View {
    @Binding var tipoSeleccionado: TipoLugar?
    
    var body: some View {
        VStack(spacing: 12) {
            // Barra superior
            HStack {
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Lugares de Interés")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Monterrey, Nuevo León")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Botones de filtro
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(TipoLugar.allCases, id: \.self) { tipo in
                        BotonFiltro(
                            tipo: tipo,
                            isSelected: tipoSeleccionado == tipo,
                            action: {
                                if tipoSeleccionado == tipo {
                                    tipoSeleccionado = nil
                                } else {
                                    tipoSeleccionado = tipo
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
        .padding(.bottom, 8)
        .background(Color(red: 0.06, green: 0.09, blue: 0.16))
    }
}

// MARK: - Botón de Filtro
struct BotonFiltro: View {
    let tipo: TipoLugar
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: tipo.icono)
                    .font(.system(size: 14))
                Text(tipo.rawValue)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.9))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected ? tipo.color.opacity(0.3) : tipo.color.opacity(0.15)
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 0)
            )
        }
    }
}

// MARK: - Lista de Lugares
struct ListaLugaresView: View {
    let lugares: [LugarInteres]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Array(lugares.enumerated()), id: \.element.id) { index, lugar in
                    TarjetaLugar(
                        lugar: lugar,
                        numero: index + 1
                    )
                }
            }
            .padding()
        }
        .background(Color(red: 0.06, green: 0.09, blue: 0.16))
    }
}

// MARK: - Tarjeta de Lugar
struct TarjetaLugar: View {
    let lugar: LugarInteres
    let numero: Int
    
    var body: some View {
        Button(action: {
            abrirEnMaps()
        }) {
            HStack(spacing: 16) {
                // Número identificador
                ZStack {
                    Circle()
                        .fill(lugar.tipo.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Text("\(numero)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(lugar.tipo.color)
                }
                
                // Información
                VStack(alignment: .leading, spacing: 4) {
                    Text(lugar.nombre)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(lugar.direccion)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    Text(lugar.tipo.rawValue)
                        .font(.caption2)
                        .foregroundColor(lugar.tipo.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(lugar.tipo.color.opacity(0.15))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                // Distancia desde el centro
                VStack(spacing: 4) {
                    if lugar.distancia < 1000 {
                        Text("\(lugar.distancia) m")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    } else {
                        Text(String(format: "%.1f km", Double(lugar.distancia) / 1000.0))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func abrirEnMaps() {
        // Crear el placemark con coordenadas y dirección
        let coordinate = lugar.coordenada
        
        // Diccionario de dirección para Maps
        let addressDict: [String: Any] = [
            CNPostalAddressStreetKey: lugar.direccion
        ]
        
        // Crear placemark con coordenadas y dirección
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: addressDict
        )
        
        // Crear MKMapItem
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = lugar.nombre
        
        // Abrir en Apple Maps con opciones de navegación
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
            MKLaunchOptionsShowsTrafficKey: true
        ])
    }
}

// MARK: - Extensión para esquinas específicas
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    MapaView()
}
