import SwiftUI

// MARK: - Models
struct Match: Identifiable {
    let id = UUID()
    let homeTeam: String
    let awayTeam: String
    let homeFlag: String
    let awayFlag: String
    let date: String
    let time: String
}

struct StadiumSection: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

struct TeamInfoItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
}

// MARK: - Vistas de Destino (Placeholders)
// (Puedes moverlas a sus propios archivos cuando quieras)

struct AlineacionesView: View {
    var body: some View {
        Text("Vista de Alineaciones")
            .navigationTitle("Alineaciones")
    }
}

// MARK: - Main View
struct EstadioView: View {
    @State private var showChat = false
    @State private var showMap = false
    @State private var chatMessage = ""
    
    let upcomingMatches = [
        Match(homeTeam: "Brasil", awayTeam: "Argentina", homeFlag: "🇧🇷", awayFlag: "🇦🇷", date: "16 Diciembre 2025", time: "19:00"),
        Match(homeTeam: "España", awayTeam: "Alemania", homeFlag: "🇪🇸", awayFlag: "🇩🇪", date: "18 Diciembre 2025", time: "21:00"),
        Match(homeTeam: "Francia", awayTeam: "Italia", homeFlag: "🇫🇷", awayFlag: "🇮🇹", date: "20 Diciembre 2025", time: "18:30")
    ]
    
    let teamInfo = [
        TeamInfoItem(icon: "person.3.fill", title: "Alineaciones", subtitle: "Ver formación del equipo", color: .blue),
        TeamInfoItem(icon: "person.2.fill", title: "Jugadores", subtitle: "Plantilla completa", color: .green),
        TeamInfoItem(icon: "trophy.fill", title: "Tabla General", subtitle: "Posiciones y estadísticas", color: .yellow)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color(hex: "#0f172a"), Color(hex: "#1e293b"), Color(hex: "#0f172a")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        HStack {
                            Text("Estadio")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        
                        // Main Match Card
                        MainMatchCard(showMap: $showMap)
                            .padding(.horizontal, 24)
                        
                        // Upcoming Matches
                        UpcomingMatchesCard(matches: upcomingMatches)
                            .padding(.horizontal, 24)
                        
                        // Team Information
                        TeamInformationCard(items: teamInfo)
                            .padding(.horizontal, 24)
                    }
                }
                
                // Chat Modal
                if showChat {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { showChat = false }
                    
                    VStack {
                        Spacer()
                        ChatAssistantView(isPresented: $showChat, message: $chatMessage)
                            .transition(.move(edge: .bottom))
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showChat)
                }
                
                // Stadium Map Modal
                if showMap {
                    Color.black.opacity(0.7)
                        .ignoresSafeArea()
                        .onTapGesture { showMap = false }
                    
                    StadiumMapView(isPresented: $showMap)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showMap)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Main Match Card
struct MainMatchCard: View {
    @Binding var showMap: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("PRÓXIMAMENTE")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(hex: "#334155"))
                .cornerRadius(20, corners: [.topLeft, .topRight])
            
            VStack(spacing: 24) {
                // Teams
                HStack(alignment: .center, spacing: 20) {
                    // Mexico
                    VStack(spacing: 12) {
                        Text("🇲🇽")
                            .font(.system(size: 55))
                        Text("México")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Score and Date
                    VStack(spacing: 8) {
                        Text("0 - 0")
                            .font(.system(size: 37, weight: .bold))
                            .foregroundColor(Color(hex: "#94a3b8"))
                        
                        Text("25 Noviembre 2025")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#94a3b8"))
                        
                        Text("20:30 hrs")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#64748b"))
                    }
                    
                    Spacer()
                    
                    // Portugal
                    VStack(spacing: 12) {
                        Text("🇵🇹")
                            .font(.system(size: 55))
                        Text("Portugal")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                
                // Stadium Button - Navega a EstadioMapView
                NavigationLink(destination: EstadioMapViewWrapper()) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 20))
                        Text("Estadio BBVA")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 24)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#1e293b"), Color(hex: "#334155")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        }
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

// MARK: - Upcoming Matches Card
struct UpcomingMatchesCard: View {
    let matches: [Match]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Próximos Partidos")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 18) {
                ForEach(matches) { match in
                    MatchRow(match: match)
                }
            }
        }
        .padding(9)
        .background(Color(hex: "#1e293b"))
        .cornerRadius(24)
    }
}

// MARK: - Match Row
struct MatchRow: View {
    let match: Match
    
    var body: some View {
        Button(action: {}) {
            HStack {
                // Teams
                HStack(spacing: 16) {
                    Text(match.homeFlag)
                        .font(.system(size: 30))
                    
                    Text("VS")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(match.awayFlag)
                        .font(.system(size: 30))
                }
                
                Spacer()
                
                // Date and Time
                HStack(spacing: 12) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(match.date)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(match.time)
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#94a3b8"))
                    }
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                        .font(.system(size: 18))
                }
            }
            .padding(16)
            .background(Color(hex: "#334155"))
            .cornerRadius(16)
        }
    }
}

// MARK: - Team Information Card
struct TeamInformationCard: View {
    let items: [TeamInfoItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información del Equipo")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                ForEach(items) { item in
                    NavigationLink(destination: destinationView(for: item.title)) {
                        TeamInfoRow(item: item)
                    }
                }
            }
        }
        .padding(8)
        .background(Color(hex: "#1e293b"))
        .cornerRadius(24)
    }
    
    @ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Alineaciones":
            Alineaciones()
        case "Jugadores":
            JugadoresView()
        case "Tabla General":
            TablaGeneralView(equipos: [])
        default:
            Text("Vista para \(title)")
        }
    }
}

// MARK: - Team Info Row
struct TeamInfoRow: View {
    let item: TeamInfoItem
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.color)
                    .frame(width: 50, height: 50)
                
                Image(systemName: item.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text(item.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#94a3b8"))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#94a3b8"))
        }
        .padding(20)
        .background(Color(hex: "#334155"))
        .cornerRadius(16)
    }
}

// MARK: - Chat Assistant View
struct ChatAssistantView: View {
    @Binding var isPresented: Bool
    @Binding var message: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "message.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Asistente BBVA")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("En línea")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(18)
                }
            }
            .padding(24)
            .background(Color.blue)
            .cornerRadius(24, corners: [.topLeft, .topRight])
            
            // Message Content
            VStack(spacing: 16) {
                HStack {
                    Text("¡Hola! 👋 Soy tu asistente del Estadio BBVA. ¿En qué puedo ayudarte?")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(16)
                        .background(Color(hex: "#334155"))
                        .cornerRadius(16)
                    
                    Spacer()
                }
                
                // Input Field
                HStack(spacing: 12) {
                    TextField("Escribe tu mensaje...", text: $message)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color(hex: "#334155"))
                        .cornerRadius(24)
                        .accentColor(.white)
                    
                    Button(action: {}) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.blue)
                            .cornerRadius(24)
                    }
                }
            }
            .padding(24)
            .background(Color(hex: "#1e293b"))
        }
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: -10)
    }
}

// MARK: - Stadium Map View
struct StadiumMapView: View {
    @Binding var isPresented: Bool
    
    let sections = [
        StadiumSection(icon: "🪑", title: "Asientos"),
        StadiumSection(icon: "🍽️", title: "Restaurantes"),
        StadiumSection(icon: "🛍️", title: "Tiendas"),
        StadiumSection(icon: "📍", title: "Zonas"),
        StadiumSection(icon: "🚻", title: "Baños")
    ]
    
    let gridSections = [
        StadiumSection(icon: "🪑", title: "Asientos"),
        StadiumSection(icon: "🍽️", title: "Restaurantes"),
        StadiumSection(icon: "🛍️", title: "Tiendas"),
        StadiumSection(icon: "📍", title: "Zonas"),
        StadiumSection(icon: "🚻", title: "Baños"),
        StadiumSection(icon: "🅿️", title: "Estacionamiento")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Estadio BBVA Bancomer")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Monterrey · Capacidad: 51,348")
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#94a3b8"))
                }
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color(hex: "#1e293b"))
                        .cornerRadius(20)
                }
            }
            
            // Section Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sections) { section in
                        HStack(spacing: 8) {
                            Text(section.icon)
                                .font(.system(size: 18))
                            Text(section.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#1e293b"))
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color(hex: "#334155"), lineWidth: 1)
                        )
                    }
                }
            }
            
            // Map Placeholder
            VStack(spacing: 16) {
                Text("🏟️")
                    .font(.system(size: 80))
                
                Text("Mapa del Estadio BBVA")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Aquí se mostrará el mapa interactivo del estadio con todas las ubicaciones de asientos, restaurantes, tiendas, baños y zonas especiales.")
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "#94a3b8"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 48)
            .background(Color(hex: "#0f172a"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: "#334155"), lineWidth: 1)
            )
            
            // Quick Access Grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(gridSections) { section in
                    VStack(spacing: 12) {
                        Text(section.icon)
                            .font(.system(size: 36))
                        Text(section.title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color(hex: "#0f172a"))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#334155"), lineWidth: 1)
                    )
                }
            }
        }
        .padding(32)
        .background(Color.black)
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color(hex: "#334155"), lineWidth: 1)
        )
        .padding(20)
    }
}

// MARK: - Stadium Map View Wrapper
struct EstadioMapViewWrapper: View {
    @State private var currentScreen: String = ""
    
    var body: some View {
        EstadioMapView(currentScreen: $currentScreen)
    }
}

// MARK: - Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
struct EstadioView_Previews: PreviewProvider {
    static var previews: some View {
        EstadioView()
    }
}
