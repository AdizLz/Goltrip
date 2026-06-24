import SwiftUI
import UIKit
import UserNotifications
import MapKit

// Función para abrir Moovit
func openMoovitApp() {
    guard let moovitURL = URL(string: "moovit://"),
          let appStoreURL = URL(string: "https://apps.apple.com/app/moovit-public-transportation/id498477945")
    else { return }
    DispatchQueue.main.async {
        UIApplication.shared.open(moovitURL, options: [:]) { success in
            if !success { UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil) }
        }
    }
}

// MARK: - Match Status Enum
enum MatchStatus { case upcoming, live, finished }


// MARK: - Models
struct Event: Identifiable, Equatable {
    let id: Int; let type: String; let title: String; let time: String
    let location: String; let city: String; let icon: String; let gradient: [Color]
    let capacity: String; let description: String; let activities: String
    let ticketURL: String?
}
struct MatchInfo: Identifiable {
    let id = UUID(); let team1Flag: String; let team1Name: String
    let team2Flag: String; let team2Name: String; let time: String
    let date: String; let stadium: String; let city: String
}

// MARK: - Main App Struct
struct FIFA2026App: View {
    @State private var activeTab = "home"
    @State private var showSettings = false
    @State private var modoApariencia: ModoApariencia = .oscuro
    @State private var selectedCity = "Monterrey"
    @State private var showCityMenu = false
    @State private var showLanguageMenu = false
    @State private var currentScreen = "home"
    @State private var selectedEvent: Event?
    @State private var selectedEventbriteEvent: EventbriteEvent? = nil
    @State private var showHelpModal = false
    @State var fetchedEventbriteEvents: [EventbriteEvent] = []
    @State var isLoadingEvents = false
    @State var eventError: Error? = nil
    @Binding var selectedLanguageIdentifier: String
    let eventbriteService = EventbriteService()

    let cities = ["Monterrey", "CDMX", "Guadalajara"]
    
    private let liveMatchDate: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM, yyyy"
            formatter.locale = Locale(identifier: "es_MX") // Asegúrate que coincida con tu formato de fecha
            return formatter.string(from: Date())
        }()
    private let liveMatchTime: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: Date())
        }()

    var body: some View {
        ZStack {
            Group {
                if isLoadingEvents {
                    ProgressView("loading.events").progressViewStyle(.circular)
                        .padding().background(.thinMaterial).cornerRadius(10)
                } else if let error = eventError {
                    /*VStack {
                        Text("error.loading_events").foregroundColor(.red)
                        Text(error.localizedDescription).font(.caption).foregroundColor(.gray)
                        Button("error.retry_button") {
                            Task { await loadEventbriteEvents(for: selectedCity) }
                        }.buttonStyle(.bordered).padding(.top)
                    }.padding().background(.thickMaterial).cornerRadius(10)*/
                }
            }.zIndex(10)

            switch currentScreen {
            case "allEvents":
                AllEventsView(
                    selectedCity: selectedCity,
                    hardcodedEvents: allEventsData,
                    isLoading: isLoadingEvents,
                    currentScreen: $currentScreen,
                    selectedHardcodedEvent: $selectedEvent)
            case "stadium":
                EstadioMapView(currentScreen: $currentScreen)
            default:
                HomeView(
                    selectedCity: $selectedCity,
                    showSettings: $showSettings,
                    showCityMenu: $showCityMenu,
                    hardcodedEvents: allEventsData,
                    isLoading: isLoadingEvents,
                    allMatchesForApp: allMatchesData,
                    currentScreen: $currentScreen,
                    selectedHardcodedEvent: $selectedEvent,
                    activeTab: $activeTab,
                    cities: cities
                )
            }

            if showSettings {
                            SettingsView(
                                showSettings: $showSettings,
                                modoApariencia: $modoApariencia,
                                selectedLanguageIdentifier: $selectedLanguageIdentifier,
                                showLanguageMenu: $showLanguageMenu,
                                showHelpModal: $showHelpModal // Pasa el binding
                            )
                            .zIndex(1).transition(.move(edge: .leading))
                        }

            if let event = selectedEvent {
                EventModalView(event: event) { selectedEvent = nil }
                    .zIndex(2).transition(.opacity.combined(with: .scale))
            }

            if let eventbriteEvent = selectedEventbriteEvent {
                EventbriteEventModalView(event: eventbriteEvent) { selectedEventbriteEvent = nil }
                    .zIndex(3).transition(.opacity.combined(with: .scale))
            }
            if showHelpModal {
                            HelpModalView(showHelp: $showHelpModal)
                                .zIndex(10)
            }
        }
        .animation(.default, value: showSettings)
        .animation(.default, value: selectedEvent != nil || selectedEventbriteEvent != nil || showHelpModal)
        .preferredColorScheme(modoApariencia.colorScheme)
    }

    /*func loadEventbriteEvents(for city: String) async {
        isLoadingEvents = true; eventError = nil
        do {
            let events = try await eventbriteService.fetchEvents(city: city)
            await MainActor.run { self.fetchedEventbriteEvents = events; self.isLoadingEvents = false; print("Fetched \(events.count) EB events for \(city)") }
        } catch {
            await MainActor.run { self.eventError = error; self.isLoadingEvents = false; self.fetchedEventbriteEvents = []; print("Error fetching EB events: \(error)") }
        }
    }*/
    
    // MARK: - Sample Data Source
    var allMatchesData: [MatchInfo] { return [
        MatchInfo(team1Flag: "🇲🇽", team1Name: "México", team2Flag: "🇵🇹", team2Name: "Portugal", time: "19:00", date: "15 Jun, 2026", stadium: "Estadio BBVA", city: "Monterrey"),
        MatchInfo(team1Flag: "🇺🇸", team1Name: "USA", team2Flag: "🇩🇪", team2Name: "Alemania", time: "21:00", date: "16 Jun, 2026", stadium: "Estadio Azteca", city: "CDMX"),
        
        // --- PARTIDO DE GUADALAJARA MODIFICADO ---
        MatchInfo(team1Flag: "🇨🇦", team1Name: "Canadá", team2Flag: "🇧🇷", team2Name: "Brasil",
                  time: liveMatchTime, // <-- HORA ACTUAL
                  date: liveMatchDate,  // <-- FECHA ACTUAL
                  stadium: "Estadio Akron", city: "Guadalajara")
    ]
    }
    
    let allEventsData: [Event] = [
        // Monterrey
        Event(id: 1, type: "FAN ZONE", title: "Macroplaza Fan Fest", time: "12:00-23:00", location: "Macroplaza", city: "Monterrey", icon: "🎉", gradient: [.orange, .yellow], capacity: "50,000", description: "Pantallas gigantes, música y comida.", activities: "Pantallas, música, comida", ticketURL: "https://www.ticketmaster.com.mx/"),
        Event(id: 2, type: "CONCIERTO", title: "FIFA World Concert", time: "20:00", location: "Arena Monterrey", city: "Monterrey", icon: "🎵", gradient: [.purple, .pink], capacity: "15,000", description: "Concierto oficial FIFA.", activities: "Artistas internacionales", ticketURL: "https://www.ticketmaster.com.mx/"),
        Event(id: 3, type: "TOUR", title: "Paseo Santa Lucía", time: "10:00", location: "Centro Monterrey", city: "Monterrey", icon: "🚶", gradient: [.blue, .cyan], capacity: "200", description: "Recorrido guiado.", activities: "Guía, paseo en lancha", ticketURL: nil),
        Event(id: 4, type: "GASTRONÓMICO", title: "Festival Gastronómico", time: "11:00-22:00", location: "Parque Fundidora", city: "Monterrey", icon: "🍴", gradient: [.red, .orange], capacity: "10,000", description: "Platillos de las naciones.", activities: "Food trucks, shows", ticketURL: "https://feverup.com/monterrey"),
        Event(id: 5, type: "DEPORTIVO", title: "Mini Copa FIFA Kids", time: "09:00-18:00", location: "Parque España", city: "Monterrey", icon: "⚽", gradient: [.green, .mint], capacity: "5,000", description: "Torneo infantil.", activities: "Torneos, clínicas", ticketURL: "https://www.fifa.com/"),
        Event(id: 6, type: "CULTURAL", title: "Expo Historia Fútbol", time: "10:00-20:00", location: "Museo del Acero", city: "Monterrey", icon: "🏆", gradient: [.yellow, .orange], capacity: "3,000", description: "Recorre la historia.", activities: "Trofeos, camisetas", ticketURL: "https://horno3.org/"),
        // CDMX
        Event(id: 11, type: "FAN ZONE", title: "Zócalo Fan Fest", time: "11:00-00:00", location: "Zócalo", city: "CDMX", icon: "🎉", gradient: [.red, .orange], capacity: "100,000", description: "El corazón de la ciudad.", activities: "Pantallas, comida, música", ticketURL: "https://www.ticketmaster.com.mx/"),
        Event(id: 12, type: "CONCIERTO", title: "Concierto Azteca FIFA", time: "21:00", location: "Estadio Azteca", city: "CDMX", icon: "🎵", gradient: [.blue, .indigo], capacity: "80,000", description: "Show inaugural.", activities: "Artistas globales", ticketURL: "https://www.ticketmaster.com.mx/"),
        Event(id: 13, type: "CULTURAL", title: "Museo Antropología", time: "10:00-18:00", location: "Museo Nacional de Antropología", city: "CDMX", icon: "🏛️", gradient: [.yellow, .brown], capacity: "5,000", description: "Exhibición especial.", activities: "Historia, artefactos", ticketURL: "https://www.mna.inah.gob.mx/"),
        Event(id: 14, type: "TOUR", title: "Xochimilco Mundialista", time: "10:00-17:00", location: "Embarcadero Nativitas", city: "CDMX", icon: "🛶", gradient: [.cyan, .green], capacity: "Variable", description: "Recorrido en trajinera.", activities: "Paseo, música, comida", ticketURL: nil),
        // Guadalajara
        Event(id: 21, type: "FAN ZONE", title: "Expo GDL Fan Fest", time: "12:00-22:00", location: "Expo Guadalajara", city: "Guadalajara", icon: "🎉", gradient: [.green, .green], capacity: "40,000", description: "Pasión tapatía.", activities: "Juegos, pantallas, mariachi", ticketURL: "https://www.ticketmaster.com.mx/"),
        Event(id: 22, type: "TOUR", title: "Tour Tequila Express", time: "09:00-19:00", location: "Estación Ferrocarril", city: "Guadalajara", icon: "🚂", gradient: [.brown, .orange], capacity: "300", description: "Viaje a Tequila.", activities: "Tren, degustación", ticketURL: "https://www.tequilaexpress.mx/"),
        Event(id: 23, type: "GASTRONÓMICO", title: "Festival Birria y Fútbol", time: "13:00-21:00", location: "Plaza Américas", city: "Guadalajara", icon: "🍲", gradient: [.red, .pink], capacity: "8,000", description: "Sabores locales.", activities: "Comida, música", ticketURL: "https://feverup.com/guadalajara"),
        Event(id: 24, type: "CULTURAL", title: "Tlaquepaque Arte", time: "11:00-19:00", location: "Centro Tlaquepaque", city: "Guadalajara", icon: "🎨", gradient: [.purple, .orange], capacity: "Variable", description: "Artesanías.", activities: "Galerías, tiendas", ticketURL: nil)
    ]
}


// MARK: - Home View
struct HomeView: View {
    @Binding var selectedCity: String
    @Binding var showSettings: Bool
    @Binding var showCityMenu: Bool
    let hardcodedEvents: [Event]
    let isLoading: Bool
    let allMatchesForApp: [MatchInfo]
    @Binding var currentScreen: String
    @Binding var selectedHardcodedEvent: Event?
    @Binding var activeTab: String
    let cities: [String]

    var mainEvents: [Event] { hardcodedEvents.filter { $0.city == selectedCity }.prefix(3).map { $0 } }
    var nextMatch: MatchInfo? { allMatchesForApp.first { $0.city == selectedCity } }

    var body: some View {
        ZStack {
            Color.theme.mainBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Button(action: { showSettings = true }) { ZStack { RoundedRectangle(cornerRadius: 16).fill(Color.theme.primaryAccent.opacity(0.2)).frame(width: 48, height: 48).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.theme.primaryAccent.opacity(0.3), lineWidth: 1)); Image(systemName: "gearshape.fill").font(.system(size: 24)).foregroundColor(Color.theme.primaryText) }}
                        VStack(alignment: .leading, spacing: 2) { Text("FIFA2026").font(.title2).fontWeight(.bold); Text("home.subtitle").font(.caption).foregroundColor(Color.theme.secondaryText) }
                        Spacer()
                        Menu { ForEach(cities, id: \.self) { city in Button(action: { selectedCity = city }) { HStack { Image(systemName: "mappin.circle.fill"); Text(city) } } } }
                         label: { HStack(spacing: 6) { Image(systemName: "location.fill").foregroundColor(.red); Text(selectedCity).fontWeight(.medium).lineLimit(1); Image(systemName: "chevron.down").foregroundColor(Color.theme.secondaryText) }.font(.subheadline).padding(.horizontal, 12).padding(.vertical, 8).background(Color.theme.cardBackground.opacity(0.7)).cornerRadius(20) }
                         .foregroundColor(Color.theme.primaryText)
                    }.padding()

                    // Next Match Card
                    if let match = nextMatch {
                        NextMatchCard(matchInfo: match).padding(.horizontal)
                    } else {
                        VStack(spacing: 8) {
                            Text("match.next").font(.subheadline).foregroundColor(Color.theme.secondaryText)
                            Spacer(minLength: 20)
                            
                            // ▼▼▼ SOLUCIÓN APLICADA AQUÍ ▼▼▼
                                                        HStack(spacing: 4) { // Añade un espaciado pequeño
                                                            Text("home.no_match") // "No hay partido programado en"
                                                            Text(selectedCity)   // "Guadalajara"
                                                        }
                                                        .font(.headline) // Aplica los modificadores al HStack
                                                        .foregroundColor(Color.theme.secondaryText)
                                                        .multilineTextAlignment(.center)
                                                        // ▲▲▲ FIN DE LA SOLUCIÓN ▲▲▲
                            Spacer(minLength: 20)
                        }
                        .padding().frame(maxWidth: .infinity).background(Color.theme.cardBackground).cornerRadius(24).padding(.horizontal)
                    }

                    // Sección Eventos Fijos
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 4) { // 'spacing: 4' añade un pequeño espacio
                                                    Text("home.featured_in") // Se traduce a "Eventos Destacados en"
                                                        .font(.title3)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.theme.primaryText)
                                                    
                                                    Text(selectedCity) // Muestra la variable "Guadalajara"
                                                        .font(.title3)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.theme.primaryText)
                                                    
                                                    Spacer() // Empuja el texto a la izquierda
                                                }
                                                .padding(.horizontal) // Aplica el padding al grupo, no a cada texto
                                                // ▲▲▲ FIN CAMBIO ▲▲▲
                        if mainEvents.isEmpty { Text("home.no_featured_events").foregroundColor(Color.theme.secondaryText).padding(.horizontal) }
                        else { ForEach(mainEvents) { event in EventCard(event: event) { selectedHardcodedEvent = event }.padding(.horizontal) }}
                        Button(action: { currentScreen = "allEvents" }) { HStack { Text("home.see_all_events").fontWeight(.bold); Image(systemName: "chevron.right") }.foregroundColor(Color.theme.primaryAccent).frame(maxWidth: .infinity).padding().background(Color.theme.primaryAccent.opacity(0.2)).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.theme.primaryAccent.opacity(0.3), lineWidth: 1)) }.padding(.horizontal)
                    }

                    

                    // Quick Access
                    VStack(alignment: .leading, spacing: 16) {
                         Text("home.quick_access").font(.title3).fontWeight(.bold).padding(.horizontal).foregroundColor(Color.theme.primaryText)
                         LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                             QuickAccessButton(icon: "🏟️", title: "home.stadium", subtitle: "home.stadium_map", color: .green) { currentScreen = "stadium" }
                             QuickAccessButton(icon: "📍", title: "home.transport", subtitle: "home.how_to_get", color: .purple) { openMoovitApp() }
                         }.padding(.horizontal)
                     }.padding(.top)

                    Spacer(minLength: 100)
                }
            }
        }
        .foregroundColor(Color.theme.primaryText)
    }
}


// MARK: - Next Match Card
struct NextMatchCard: View {
    let matchInfo: MatchInfo
    @State private var notificationsEnabled = false
    @State private var currentMatchStatus: MatchStatus = .upcoming
    @State private var now = Date()
    @State private var showingNotificationAlert = false
    @State private var alertMessageKey: LocalizedStringKey = ""

    // --- Estados para Marcador ---
    @State private var team1Score = 0
    @State private var team2Score = 0
    
    // Timers
    let statusTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Timer de 1 min para estado (live/finished)
    let goalTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect() // Timer de 10s para marcador (solo en app)

    // Parseo de fechas (con coma)
    var matchStartDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy, HH:mm" // Formato con coma
        formatter.locale = Locale(identifier: "es_MX")
        let dateString = "\(matchInfo.date), \(matchInfo.time)"
        return formatter.date(from: dateString)
    }
    var matchEndDate: Date? { matchStartDate?.addingTimeInterval(2 * 60 * 60) } // 2 horas

    var body: some View {
        VStack(spacing: 10) {
            // Header (Campana)
            HStack {
                Text("match.next").foregroundColor(Color.theme.secondaryText).font(.caption)
                Spacer()
                Button { toggleNotifications() } label: { Image(systemName: notificationsEnabled ? "bell.fill" : "bell").foregroundColor(.blue) }
            }
            
            VStack(spacing: 10) {
                // Indicador "En Vivo"
                if currentMatchStatus == .live {
                    HStack(spacing: 4){
                        Image(systemName: "circle.fill").foregroundColor(.red).font(.caption2)
                        Text("match.live").font(.caption2).fontWeight(.bold).foregroundColor(.red)
                    }
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(Color.red.opacity(0.2)).cornerRadius(12)
                }
                
                // Equipos, Hora y MARCADOR
                HStack(alignment: .center, spacing: 15) {
                    VStack { Text(matchInfo.team1Flag).font(.system(size: 36)); Text(LocalizedStringKey(matchInfo.team1Name)).font(.caption).fontWeight(.semibold).lineLimit(1) }.frame(width: 60)
                    
                    // Condición de vista (En Vivo vs Próximo)
                    if currentMatchStatus == .live {
                        // VISTA EN VIVO (Marcador grande)
                        VStack {
                            Text("\(team1Score) : \(team2Score)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color.theme.primaryText)
                                .minimumScaleFactor(0.8)
                            Text(matchInfo.time).font(.subheadline).foregroundColor(Color.theme.secondaryText)
                        }
                    } else {
                        // VISTA PRÓXIMO (Hora grande)
                        VStack {
                            Text(matchInfo.time).font(.system(size: 40, weight: .bold)).foregroundColor(Color.blue)
                            Text("- : -").font(.subheadline).foregroundColor(Color.theme.secondaryText)
                        }
                    }
                    
                    VStack { Text(matchInfo.team2Flag).font(.system(size: 36)); Text(LocalizedStringKey(matchInfo.team2Name)).font(.caption).fontWeight(.semibold).lineLimit(1) }.frame(width: 60)
                }

                // Lugar y Fecha
                VStack(spacing: 4) {
                    HStack { Image(systemName: "mappin.circle.fill").foregroundColor(.red).font(.caption); Text(matchInfo.stadium).lineLimit(1) }
                    HStack { Image(systemName: "calendar").foregroundColor(Color.theme.primaryAccent); Text(matchInfo.date) }
                }.font(.caption).foregroundColor(Color.theme.secondaryText)
                
            }
            .padding(.vertical, 10).padding(.horizontal).background(Color.theme.cardBackground).cornerRadius(16)
        }
        .padding(.vertical, 10).padding(.horizontal)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.theme.cardBackground).overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.2), lineWidth: 1)))
        .foregroundColor(Color.theme.primaryText)
        .onReceive(statusTimer) { inputTime in // Timer de 1 min
            now = inputTime
            updateMatchStatus()
        }
        .onReceive(goalTimer) { _ in // Timer de 10 seg
            simulateScoreUpdateInApp() // Solo actualiza la UI
        }
        .onAppear {
            updateMatchStatus()
            checkNotificationStatusOnAppear()
        }
        .alert(Text("alert.notifications_title"), isPresented: $showingNotificationAlert) { Button("OK"){ } } message: { Text(alertMessageKey) }
    }

    // --- FUNCIONES ---

    func updateMatchStatus() {
        guard let start = matchStartDate, let end = matchEndDate else { currentMatchStatus = .upcoming; return }
        if now >= start && now < end { currentMatchStatus = .live }
        else if now >= end { currentMatchStatus = .finished }
        else { currentMatchStatus = .upcoming }
    }

    /// (SOLO UI) Actualiza el marcador visible CADA 10s si la app está abierta
    func simulateScoreUpdateInApp() {
        guard currentMatchStatus == .live else { return } // Solo si está en vivo
        if Bool.random() { team1Score += 1 } else { team2Score += 1 }
    }

    // ▼▼▼ LÓGICA DE LA CAMPANA MODIFICADA ▼▼▼
    func toggleNotifications() {
        if notificationsEnabled {
            // --- Desactivar ---
            self.notificationsEnabled = false
            self.alertMessageKey = "alert.notif_disabled"
            self.showingNotificationAlert = true
            print("Notificaciones Desactivadas. Cancelando notificaciones pendientes.")
            
            // Cancela las notificaciones que programamos antes
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["goal_1", "goal_2", "goal_3", "goal_4", "goal_5"])
            
        } else {
            // --- Activar ---
            requestNotificationPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.notificationsEnabled = true
                        self.alertMessageKey = "alert.notif_enabled"
                        print("Notificaciones Activadas. Programando 5 goles falsos para segundo plano.")
                        
                        // Programa las notificaciones que SÍ funcionarán en segundo plano
                        scheduleFakeGoalNotifications()
                        
                    } else {
                        self.notificationsEnabled = false
                        self.alertMessageKey = "alert.notif_denied"
                        print("Permiso de notificación denegado.")
                    }
                    self.showingNotificationAlert = true
                }
            }
        }
    }
    
    /// (SOLO SEGUNDO PLANO) Programa 5 notificaciones futuras al presionar la campana
    func scheduleFakeGoalNotifications() {
        // Nombres ya traducidos por NSLocalizedString
        let team1Name = NSLocalizedString(matchInfo.team1Name, comment: "")
        let team2Name = NSLocalizedString(matchInfo.team2Name, comment: "")

        // Marcadores falsos
        let goals = [
            (time: 10.0, scorer: team1Name, score: "1 - 0"), // A los 10s
            (time: 20.0, scorer: team2Name, score: "1 - 1"), // A los 20s
            (time: 30.0, scorer: team1Name, score: "2 - 1"), // A los 30s
            (time: 40.0, scorer: team1Name, score: "3 - 1"), // A los 40s
            (time: 50.0, scorer: team2Name, score: "3 - 2")  // A los 50s
        ]

        let title = NSLocalizedString("notif.goal_title", comment: "Goal!")
        let bodyFormat = NSLocalizedString("notif.goal_body", comment: "Goal for %@! Score: %@")

        for (index, goal) in goals.enumerated() {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = String(format: bodyFormat, goal.scorer, goal.score)
            content.sound = .default

            // Programa la notificación para el futuro
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: goal.time, repeats: false)
            // Identificador único para poder cancelarla después
            let request = UNNotificationRequest(identifier: "goal_\(index + 1)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error { print("Error programando gol falso \(index + 1): \(error)") }
                else { print("Gol falso \(index + 1) programado para T+\(goal.time)s") }
            }
        }
    }
    
    // (Esta función se queda igual)
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { g, e in completion(g) }
    }
    
    // (Esta función se queda igual)
    func checkNotificationStatusOnAppear() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus != .authorized { self.notificationsEnabled = false }
            }
        }
    }
}

// (Ya no necesitas la extensión para LocalizedStringKey.stringKey)

// MARK: - Event Card (Para fijos)
struct EventCard: View {
     let event: Event; let action: () -> Void
     var body: some View {
         Button(action: action) {
             HStack(spacing: 16) {
                 ZStack { RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: event.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 64, height: 64); Text(event.icon).font(.system(size: 32)) }
                 VStack(alignment: .leading, spacing: 6) {
                     Text(LocalizedStringKey(event.type)).font(.caption).fontWeight(.bold).foregroundColor(Color.blue)
                     Text(event.title).font(.headline).fontWeight(.bold).lineLimit(1)
                     HStack(spacing: 12) {
                         HStack(spacing: 4) { Image(systemName: "calendar"); Text(event.time) }
                         HStack(spacing: 4) { Image(systemName: "mappin.circle.fill").foregroundColor(.red); Text(event.location) }
                     }.font(.caption).foregroundColor(Color.theme.secondaryText)
                 }
                 Spacer()
             }
             .padding().background(Color.theme.cardBackground).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
         }.buttonStyle(PlainButtonStyle()).foregroundColor(Color.theme.primaryText)
     }
}


// MARK: - Quick Access Button
struct QuickAccessButton: View {
     let icon: String
     let title: LocalizedStringKey
     let subtitle: LocalizedStringKey
     let color: Color
     let action: () -> Void
     var body: some View {
         Button(action: action) {
             VStack(spacing: 8) {
                 Text(icon).font(.system(size: 40))
                 Text(title).fontWeight(.bold).foregroundColor(Color.theme.primaryText)
                 Text(subtitle).font(.caption).foregroundColor(color)
             }
             .frame(maxWidth: .infinity).padding().background(color.opacity(0.2)).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.3), lineWidth: 1))
         }.buttonStyle(PlainButtonStyle())
     }
}

// MARK: - Settings View
struct SettingsView: View {
     @Binding var showSettings: Bool
     @Binding var modoApariencia: ModoApariencia
     @Binding var selectedLanguageIdentifier: String
     @Binding var showLanguageMenu: Bool
     @Binding var showHelpModal: Bool // Recibe el binding para el modal de ayuda
    
    // Helper para mostrar el nombre correcto del idioma
         var currentLanguageName: LocalizedStringKey {
             // Lee el String "es" o "en" y devuelve la llave de localización correcta
             selectedLanguageIdentifier == "en" ? Language.english.name : Language.espanol.name
         }
    
     var iconoModo: String { switch modoApariencia { case .sistema: return "gearshape"; case .claro: return "sun.max.fill"; case .oscuro: return "moon.fill"} }
     
     var body: some View {
         ZStack {
              Color.black.opacity(0.7).ignoresSafeArea().onTapGesture { showSettings = false }
              VStack {
                  VStack(alignment: .leading, spacing: 0) {
                      HStack {
                          Text("settings.title").font(.title2).fontWeight(.bold)
                          Spacer(); Button(action: { showSettings = false }) { Image(systemName: "xmark").font(.title3).padding(8).background(Color.gray.opacity(0.2)).cornerRadius(8) }
                      }.padding().background(Color.theme.cardBackground).foregroundColor(Color.theme.primaryText)
                      
                      VStack(spacing: 8) {
                          // Menú Apariencia
                          Menu {
                              ForEach(ModoApariencia.allCases, id: \.id) { modo in
                                  Button { modoApariencia = modo } label: { Text(modo.name) }
                              }
                          } label: {
                              HStack { Image(systemName: iconoModo).foregroundColor(modoApariencia == .claro ? .yellow : Color.theme.primaryAccent); VStack(alignment: .leading) { Text("settings.display_mode").fontWeight(.semibold); Text(modoApariencia.name).font(.caption).foregroundColor(Color.theme.secondaryText) }; Spacer(); Image(systemName: "chevron.up.chevron.down").foregroundColor(Color.theme.secondaryText) }.padding().background(Color.gray.opacity(0.1)).cornerRadius(12)
                          }
                          .foregroundColor(Color.theme.primaryText)
                          
                          // Menú Idioma
                          Menu {
                              ForEach(Language.allCases, id: \.id) { lang in
                                                                Button(lang.name) {
                                                                    selectedLanguageIdentifier = lang.identifier
                                                                }
                                                            }
                          } label: {
                              HStack {
                                  Image(systemName: "globe").foregroundColor(.green)
                                  VStack(alignment: .leading) {
                                      Text("settings.language").fontWeight(.semibold)
                                      Text(currentLanguageName).font(.caption).foregroundColor(Color.theme.secondaryText)
                                  }
                                  Spacer()
                                  Image(systemName: "chevron.right").foregroundColor(Color.theme.secondaryText)
                              }.padding().background(Color.gray.opacity(0.1)).cornerRadius(12)
                          }
                          .foregroundColor(Color.theme.primaryText)

                          // ▼▼▼ LÓGICA DE ACCIÓN CORREGIDA ▼▼▼
                          // Este botón define la acción para ir a Ajustes
                          SettingsButton(
                              icon: "shield.fill", // Icono de escudo para permisos
                              title: "settings.permissions",
                              subtitle: "settings.permissions.subtitle",
                              color: .purple
                          ) {
                              // Esta es la URL que abre la página de Ajustes de TU APP
                              guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                              if UIApplication.shared.canOpenURL(url) {
                                  UIApplication.shared.open(url)
                              }
                          }
                          
                          // Este botón define la acción para mostrar el modal de ayuda
                          SettingsButton(
                              icon: "questionmark.circle.fill",
                              title: "settings.help",
                              subtitle: "settings.help.subtitle",
                              color: .orange
                          ) {
                              showHelpModal = true
                          }
                          // ▲▲▲ FIN CORRECCIÓN ▲▲▲
                      }.padding()
                  }.background(Color.theme.cardBackground).cornerRadius(24).padding()
              }
          }.foregroundColor(Color.theme.primaryText)
      }
}

// MARK: - Settings Button Row
struct SettingsButton: View {
     let icon: String
     let title: LocalizedStringKey
     let subtitle: LocalizedStringKey
     let color: Color
     let action: () -> Void // Recibe una acción
    
     var body: some View {
         // ▼▼▼ CORREGIDO: El botón solo debe ejecutar la 'action' que recibe ▼▼▼
         Button(action: action) {
         // ▲▲▲ FIN CORRECCIÓN ▲▲▲
              HStack {
                  Image(systemName: icon).foregroundColor(color);
                  VStack(alignment: .leading) {
                      Text(title).fontWeight(.semibold)
                      Text(subtitle).font(.caption).foregroundColor(Color.theme.secondaryText)
                  }
                  Spacer(); Image(systemName: "chevron.right").foregroundColor(Color.theme.secondaryText)
              }.padding().background(Color.gray.opacity(0.1)).cornerRadius(12)
          }.buttonStyle(PlainButtonStyle())
      }
}

// MARK: - All Events View
struct AllEventsView: View {
     let selectedCity: String
     let hardcodedEvents: [Event]
     let isLoading: Bool
     @Binding var currentScreen: String
     @Binding var selectedHardcodedEvent: Event?

     var filteredHardcodedEvents: [Event] { hardcodedEvents.filter { $0.city == selectedCity } }

     var body: some View {
         ZStack {
             Color.theme.mainBackground.ignoresSafeArea()
             VStack(spacing: 0) {
                 HStack {
                     Button(action: { currentScreen = "home" }) { Image(systemName: "chevron.left").font(.title3).padding(8).background(Color.gray.opacity(0.2)).cornerRadius(8).foregroundColor(Color.theme.primaryAccent) }
                     VStack(alignment: .leading) { Text("events.title").font(.title2).fontWeight(.bold); Text(selectedCity).font(.subheadline).foregroundColor(Color.theme.secondaryText) }
                     Spacer()
                 }.padding([.horizontal, .top]).padding(.bottom, 8).background(Color.theme.mainBackground).foregroundColor(Color.theme.primaryText)

                 ScrollView {
                     VStack(spacing: 30) {
                         // Sección Fijos
                         VStack(alignment: .leading, spacing: 12) {
                             if !filteredHardcodedEvents.isEmpty {
                                 Text("events.featured.title").font(.title2).fontWeight(.semibold).padding(.horizontal)
                                 ForEach(filteredHardcodedEvents) { event in
                                     EventCard(event: event) { selectedHardcodedEvent = event }.padding(.horizontal)
                                 }
                             } else { Text("home.no_featured_events").foregroundColor(Color.theme.secondaryText).padding() }
                         }                     }.padding(.vertical).padding(.bottom, 80)
                 }
             }
         }
         .foregroundColor(Color.theme.primaryText)
     }
}


// MARK: - Stadium View
struct StadiumView: View {
     @Binding var currentScreen: String; let city: String
    
     var stadiumName: String {
         switch city {
         case "Monterrey": return "Estadio BBVA"
         case "CDMX": return "Estadio Azteca"
         case "Guadalajara": return "Estadio Akron"
         default: return "Estadio"
         }
     }
     var stadiumCapacity: String {
         switch city {
         case "Monterrey": return "53,500"
         case "CDMX": return "87,523"
         case "Guadalajara": return "48,071"
         default: return "N/A"
         }
     }
    
     var body: some View {
         ZStack {
             Color.theme.mainBackground.ignoresSafeArea()
             VStack(spacing: 0) {
                 HStack { Button(action: { currentScreen = "home" }) { Image(systemName: "chevron.left").font(.title3).padding(8).background(Color.gray.opacity(0.2)).cornerRadius(8).foregroundColor(Color.theme.primaryAccent) }; VStack(alignment: .leading) { Text(stadiumName).font(.title2).fontWeight(.bold); Text("stadium.subtitle").font(.subheadline).foregroundColor(Color.theme.secondaryText) }; Spacer() }.padding([.horizontal, .top]).padding(.bottom, 8).background(Color.theme.mainBackground).foregroundColor(Color.theme.primaryText)
                 ScrollView {
                     VStack(spacing: 25) {
                         VStack { Text("🏟️").font(.system(size: 80)).padding(.bottom, 5); Text("stadium.view").font(.title3).fontWeight(.bold); // ▼▼▼ SOLUCIÓN APLICADA AQUÍ ▼▼▼
                             HStack(spacing: 4) {
                                 Text("stadium.capacity") // "Capacidad:"
                                 Text(stadiumCapacity)       // "53,500"
                                 Text("stadium.people_label") // "personas"
                             }
                             .font(.subheadline)
                             .foregroundColor(Color.theme.secondaryText)
                             }.frame(maxWidth: .infinity).padding().background(Color.theme.cardBackground).cornerRadius(24).padding(.horizontal)
                         VStack(alignment: .leading, spacing: 12) { Text("stadium.facilities").font(.title2).fontWeight(.semibold).padding(.horizontal);
                             StadiumFeature(icon: "person.3.fill", title: "stadium.seats", subtitle: "stadium.seats.desc", colors: [.blue, .cyan])
                             StadiumFeature(icon: "fork.knife", title: "stadium.food", subtitle: "stadium.food.desc", colors: [.red, .orange])
                             StadiumFeature(icon: "figure.roll", title: "stadium.accessibility", subtitle: "stadium.accessibility.desc", colors: [.indigo, .blue])
                         }.foregroundColor(Color.theme.primaryText)
                         VStack(alignment: .leading, spacing: 12) { HStack { Image(systemName: "bell.fill").foregroundColor(Color.theme.primaryAccent); Text("stadium.important").fontWeight(.bold).font(.title3) }; VStack(alignment: .leading, spacing: 8) { InfoItem(text: "stadium.info1"); InfoItem(text: "stadium.info2"); InfoItem(text: "stadium.info3") } }.padding().background(Color.theme.primaryAccent.opacity(0.2)).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.theme.primaryAccent.opacity(0.3), lineWidth: 1)).padding(.horizontal).padding(.bottom, 80).foregroundColor(Color.theme.primaryText)
                     }.padding(.vertical)
                 }
             }
         }
     }
}


// MARK: - Stadium Feature Row
struct StadiumFeature: View {
     let icon: String; let title: LocalizedStringKey; let subtitle: LocalizedStringKey; let colors: [Color]
     var body: some View {
         Button(action: {}) {
              HStack(spacing: 16) {
                  ZStack { RoundedRectangle(cornerRadius: 12).fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 48, height: 48); Image(systemName: icon).font(.system(size: 20)).foregroundColor(.white) }
                  VStack(alignment: .leading, spacing: 4) { Text(title).fontWeight(.bold); Text(subtitle).font(.caption).foregroundColor(Color.theme.secondaryText) }
                  Spacer()
                  Image(systemName: "chevron.right").foregroundColor(Color.theme.secondaryText)
              }.padding().background(Color.theme.cardBackground).cornerRadius(16).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
          }.buttonStyle(PlainButtonStyle()).padding(.horizontal).foregroundColor(Color.theme.primaryText)
      }
}

// MARK: - Info Item Row
struct InfoItem: View {
     let text: LocalizedStringKey
     var body: some View {
         HStack(alignment: .top, spacing: 8) { Text("•").foregroundColor(Color.theme.secondaryText); Text(text).font(.subheadline).foregroundColor(Color.theme.secondaryText) }
     }
}

// MARK: - Event Modal View (Para fijos)
struct EventModalView: View {
     let event: Event; let onClose: () -> Void
     @Environment(\.openURL) var openURL
     var body: some View {
         ZStack {
              Color.black.opacity(0.85).ignoresSafeArea().onTapGesture(perform: onClose)
              ScrollView(.vertical, showsIndicators: false) {
                  VStack(alignment: .leading, spacing: 20) {
                      HStack { Spacer(); Button(action: onClose) { Image(systemName: "xmark").font(.title3).padding(12).background(Color.gray.opacity(0.5)).clipShape(Circle()).foregroundColor(.white) }}
                      HStack(spacing: 16) { ZStack { RoundedRectangle(cornerRadius: 16).fill(LinearGradient(colors: event.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)).frame(width: 64, height: 64); Text(event.icon).font(.system(size: 32)) }; VStack(alignment: .leading, spacing: 4) { Text(LocalizedStringKey(event.type)).font(.caption).fontWeight(.bold).foregroundColor(Color.theme.primaryAccent); Text(event.title).font(.title2).fontWeight(.bold) } }
                      VStack(spacing: 16) { HStack(spacing: 12) { Image(systemName: "mappin.circle.fill").foregroundColor(.red); Text(event.location) }; HStack(spacing: 12) { Image(systemName: "calendar").foregroundColor(Color.theme.primaryAccent); Text(event.time) }; VStack(alignment: .leading, spacing: 8) { Text("modal.capacity").font(.subheadline).foregroundColor(Color.theme.secondaryText); Text(event.capacity).font(.title3).fontWeight(.bold) }.frame(maxWidth: .infinity, alignment: .leading).padding().background(Color.gray.opacity(0.2)).cornerRadius(12) }.foregroundColor(Color.theme.secondaryText)
                      VStack(alignment: .leading, spacing: 8) { Text("modal.description").font(.headline).fontWeight(.semibold); Text(event.description).font(.subheadline).foregroundColor(Color.theme.secondaryText).lineSpacing(4) }
                      VStack(alignment: .leading, spacing: 8) { Text("modal.activities").font(.headline).fontWeight(.semibold); Text(event.activities).font(.subheadline).foregroundColor(Color.theme.secondaryText) }
                      HStack(spacing: 12) {
                          Button(action: openMap) { Text("modal.map_button").fontWeight(.semibold).frame(maxWidth: .infinity).padding().background(Color.gray.opacity(0.3)).cornerRadius(12) }
                          if event.ticketURL != nil { Button(action: openTickets) { Text("modal.tickets_button").fontWeight(.semibold).frame(maxWidth: .infinity).padding().background(LinearGradient(colors: [Color.theme.primaryAccent, .purple], startPoint: .leading, endPoint: .trailing)).cornerRadius(12).foregroundColor(.white) } }
                      }
                  }.padding().background(Color.theme.cardBackground).cornerRadius(24).overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.3), lineWidth: 1)).padding()
              }
          }.foregroundColor(Color.theme.primaryText)
      }
    
     func openMap() {
         let addressString = "\(event.location), \(event.city)"; CLGeocoder().geocodeAddressString(addressString) { (placemarks, error) in if let placemark = placemarks?.first, let location = placemark.location { let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate)); mapItem.name = event.title; mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]) } else { print("Error geocoding: \(error?.localizedDescription ?? "unknown")"); let query = addressString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""; if let url = URL(string: "https://maps.apple.com/?q=\(query)") { openURL(url) } } }
     }
     func openTickets() {
         guard let urlString = event.ticketURL, let url = URL(string: urlString) else { print("Invalid ticket URL: \(event.ticketURL ?? "nil")"); return }; openURL(url)
     }
}

// MARK: - Help Modal View
struct HelpModalView: View {
    @Binding var showHelp: Bool
    
    // ▼▼▼ AÑADIDO: Para abrir links de email/web ▼▼▼
    @Environment(\.openURL) var openURL
    // ▲▲▲ FIN AÑADIDO ▲▲▲

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { showHelp = false }
            
            VStack(alignment: .leading, spacing: 20) {
                // Header con Título y Botón de Cerrar
                HStack {
                    Text("help.title") // "Ayuda y Soporte"
                        .font(.title2).fontWeight(.bold)
                    Spacer()
                    Button(action: { showHelp = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.7))
                    }
                }
                .padding(.bottom, 10)

                // Contenido de la Ayuda
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        HelpFAQ(question: "help.faq1.q", answer: "help.faq1.a")
                        Divider()
                        HelpFAQ(question: "help.faq2.q", answer: "help.faq2.a")
                        Divider()
                        HelpFAQ(question: "help.faq3.q", answer: "help.faq3.a")
                        
                        // ▼▼▼ SECCIÓN DE CONTACTO AÑADIDA ▼▼▼
                        Divider()
                            .padding(.vertical, 10)
                        
                        Text("help.contact.title") // "Contáctanos"
                            .font(.title3).fontWeight(.bold)
                            .padding(.bottom, 5)

                        // Botón de Email
                        Button(action: {
                            if let url = URL(string: "mailto:soporte.fifa2026@example.com") {
                                openURL(url)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(Color.theme.primaryAccent)
                                    .frame(width: 20)
                                Text("soporte.fifa2026@example.com")
                                    .foregroundColor(Color.theme.secondaryText)
                                Spacer()
                            }
                        }
                        .padding(.bottom, 5)

                        // Botón de Sitio Web
                        Button(action: {
                            if let url = URL(string: "https://www.fifa.com/contact") {
                                openURL(url)
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "globe")
                                    .foregroundColor(Color.theme.primaryAccent)
                                    .frame(width: 20)
                                Text("help.contact.website") // "Sitio web de Soporte"
                                    .foregroundColor(Color.theme.secondaryText)
                                Spacer()
                            }
                        }
                        // ▲▲▲ FIN SECCIÓN DE CONTACTO ▲▲▲
                    }
                }
                .buttonStyle(PlainButtonStyle()) // Asegura que los botones no se vean azules por defecto
            }
            .padding(25)
            .background(Color.theme.cardBackground)
            .cornerRadius(24)
            .padding(30)
            .transition(.opacity.combined(with: .scale(scale: 0.9)))
            
        }
        .foregroundColor(Color.theme.primaryText)
    }
}

// Pequeña vista helper para las preguntas frecuentes (FAQ)
struct HelpFAQ: View {
    let question: LocalizedStringKey
    let answer: LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(question)
                .fontWeight(.bold)
                .foregroundColor(Color.theme.primaryText)
            Text(answer)
                .font(.subheadline)
                .foregroundColor(Color.theme.secondaryText)
                .lineSpacing(3)
        }
    }
}

// MARK: - Preview Provider
struct FIFA2026App_Previews: PreviewProvider {
    static var previews: some View {
        FIFA2026App(selectedLanguageIdentifier: .constant("es"))
            .environment(\.locale, .init(identifier: "en"))
    }
}
