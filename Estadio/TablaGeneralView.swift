import SwiftUI
import WebKit

// MARK: - HOME VIEW PRINCIPAL
struct TablaGeneralView: View {
    let equipos: [Equipo]
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedSection = 0 // 0 = Partidos, 1 = Clasificación
    @State private var selectedCountry = "México"
    @State private var selectedFlag = "🇲🇽"
    @State private var showingCountryPicker = false
    @Environment(\.dismiss) var dismiss

    let countries = [
        ("México", "🇲🇽"),
        ("Estados Unidos", "🇺🇸"),
        ("Canadá", "🇨🇦"),
        ("Brasil", "🇧🇷"),
        ("Argentina", "🇦🇷"),
        ("España", "🇪🇸"),
        ("Alemania", "🇩🇪"),
        ("Francia", "🇫🇷"),
        ("Italia", "🇮🇹"),
        ("Inglaterra", "🏴󠁧󠁢󠁥󠁮󠁧󠁿"),
        ("Portugal", "🇵🇹"),
        ("Países Bajos", "🇳🇱"),
        ("Colombia", "🇨🇴"),
        ("Uruguay", "🇺🇾"),
        ("Chile", "🇨🇱")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo consistente con JugadoresView
                Color(red: 0.11, green: 0.13, blue: 0.18)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header mejorado
                    VStack(spacing: 16) {
                        // Botón de regreso
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                    Text("Atrás")
                                        .font(.system(size: 16))
                                }
                                .foregroundColor(.cyan)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Título con país seleccionado
                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedCountry)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Mundial 2026")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Button(action: { showingCountryPicker = true }) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                                        .frame(width: 56, height: 56)
                                    
                                    Text(selectedFlag)
                                        .font(.system(size: 32))
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        
                        // Tabs personalizadas
                        HStack(spacing: 0) {
                            ForEach(["Partidos", "Clasificación"], id: \.self) { option in
                                let isSelected = selectedSection == (option == "Partidos" ? 0 : 1)
                                
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedSection = option == "Partidos" ? 0 : 1
                                    }
                                } label: {
                                    VStack(spacing: 10) {
                                        Text(option)
                                            .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                                            .foregroundColor(isSelected ? .white : .white.opacity(0.5))
                                        
                                        Rectangle()
                                            .fill(isSelected ? Color.cyan : Color.clear)
                                            .frame(height: 3)
                                            .cornerRadius(1.5)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    }
                    .padding(.bottom, 8)
                    .background(
                        Color(red: 0.09, green: 0.11, blue: 0.15)
                    )
                    
                    // Contenido
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            if selectedSection == 0 {
                                LiveGamesWidgetView()
                                    .frame(height: 700)
                                    .padding(.top, 8)
                            } else {
                                ClasificacionConcacafView()
                                    .frame(height: 700)
                                    .padding(.top, 8)
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingCountryPicker) {
                CountryPickerSheet(
                    countries: countries,
                    selectedCountry: $selectedCountry,
                    selectedFlag: $selectedFlag,
                    isPresented: $showingCountryPicker
                )
            }
        }
    }
}

// MARK: - COUNTRY PICKER SHEET
struct CountryPickerSheet: View {
    let countries: [(String, String)]
    @Binding var selectedCountry: String
    @Binding var selectedFlag: String
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.13, blue: 0.18)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(countries, id: \.0) { country, flag in
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    selectedCountry = country
                                    selectedFlag = flag
                                }
                                isPresented = false
                            }) {
                                HStack(spacing: 16) {
                                    Text(flag)
                                        .font(.system(size: 32))
                                    
                                    Text(country)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    if selectedCountry == country {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.cyan)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Seleccionar País")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        isPresented = false
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
    }
}

// MARK: - VIEWMODEL
class HomeViewModel: ObservableObject {
    // ViewModel vacío - toda la lógica está en los widgets
}

// MARK: - MODELOS API
struct EquipoResponse: Codable {
    let response: [EquipoData]
}

struct EquipoData: Codable {
    let team: Team
    let venue: Venue
}

struct Team: Codable {
    let id: Int
    let name: String
    let code: String?
    let country: String
    let founded: Int?
    let logo: String
}

struct Venue: Codable {
    let id: Int?
    let name: String?
    let city: String?
}

struct FixtureResponse: Codable {
    let response: [Fixture]
}

struct Fixture: Codable {
    let fixture: FixtureDetail
    let league: League
    let teams: Teams
    let goals: Goals
}

struct FixtureDetail: Codable {
    let id: Int
    let date: String
    let status: FixtureStatus
}

struct FixtureStatus: Codable {
    let short: String
    let long: String
}

struct League: Codable {
    let id: Int
    let name: String
    let country: String
    let logo: String
    let flag: String?
}

struct Teams: Codable {
    let home: TeamInfo
    let away: TeamInfo
}

struct TeamInfo: Codable {
    let id: Int
    let name: String
    let logo: String
}

struct Goals: Codable {
    let home: Int?
    let away: Int?
}

// MARK: - MODELOS STANDINGS
struct StandingsResponse: Codable {
    let response: [LeagueStandings]
}

struct LeagueStandings: Codable {
    let league: LeagueInfo
}

struct LeagueInfo: Codable {
    let id: Int
    let name: String
    let country: String
    let logo: String
    let standings: [[StandingTeam]]
}

struct StandingTeam: Codable {
    let rank: Int
    let team: TeamInfo
    let points: Int
    let goalsDiff: Int
    let form: String?
    let status: String?
    let all: MatchStats
}

struct MatchStats: Codable {
    let played: Int
    let win: Int
    let draw: Int
    let lose: Int
    let goals: StandingGoals
}

struct StandingGoals: Codable {
    let `for`: Int
    let against: Int
}

// MARK: - VISTA DETALLE DE EQUIPO
struct PaisDetailView: View {
    let teamId: Int
    let teamName: String
    let teamLogo: String
    
    @StateObject private var viewModel = PaisDetailViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.13, blue: 0.18)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header del equipo
                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: teamLogo)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        Text(teamName)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Selector de pestañas
                    Picker("Vista", selection: $selectedTab) {
                        Text("Equipo").tag(0)
                        Text("Partidos").tag(1)
                        Text("Clasificación").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Contenido según pestaña
                    switch selectedTab {
                    case 0:
                        WidgetWebView(widgetType: .team(teamId: teamId))
                            .frame(height: 600)
                            .padding(.horizontal)
                        
                    case 1:
                        if viewModel.isLoading {
                            ProgressView("Cargando partidos...")
                                .foregroundColor(.white)
                                .padding()
                        } else if !viewModel.fixtures.isEmpty {
                            VStack(spacing: 16) {
                                ForEach(viewModel.fixtures.prefix(5), id: \.fixture.id) { fixture in
                                    PartidoCardConWidget(fixture: fixture)
                                }
                            }
                        }
                        
                    case 2:
                        if let firstFixture = viewModel.fixtures.first {
                            WidgetWebView(widgetType: .standings(
                                leagueId: firstFixture.league.id,
                                season: Calendar.current.component(.year, from: Date())
                            ))
                            .frame(height: 800)
                            .padding(.horizontal)
                        } else {
                            Text("Cargando clasificación...")
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadData(teamId: teamId)
        }
    }
}

// MARK: - TARJETA DE PARTIDO CON WIDGET
struct PartidoCardConWidget: View {
    let fixture: Fixture
    @State private var showWidget = false
    
    var dateFormatted: String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: fixture.fixture.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            formatter.locale = Locale(identifier: "es_MX")
            return formatter.string(from: date)
        }
        return ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation {
                    showWidget.toggle()
                }
            } label: {
                VStack(spacing: 12) {
                    Text(dateFormatted)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: fixture.teams.home.logo)) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 40, height: 40)
                            
                            Text(fixture.teams.home.name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 4) {
                            if fixture.fixture.status.short == "FT" {
                                HStack(spacing: 8) {
                                    Text("\(fixture.goals.home ?? 0)")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                    Text("-")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    Text("\(fixture.goals.away ?? 0)")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                Text("Ver detalles")
                                    .font(.caption)
                                    .foregroundColor(.cyan)
                            } else {
                                Text("vs")
                                    .font(.title3)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        VStack(spacing: 8) {
                            AsyncImage(url: URL(string: fixture.teams.away.logo)) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 40, height: 40)
                            
                            Text(fixture.teams.away.name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                )
            }
            
            if showWidget {
                WidgetWebView(widgetType: .game(fixtureId: fixture.fixture.id))
                    .frame(height: 500)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - WIDGET DE PARTIDOS DE LA SELECCIÓN MEXICANA
struct LiveGamesWidgetView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        webView.backgroundColor = UIColor(red: 0.11, green: 0.13, blue: 0.18, alpha: 1.0)
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let apiKey = Config.apiSportsKey
        let mexicoTeamId = 1499
        
        let htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <script type="module" src="https://widgets.api-sports.io/3.1.0/widgets.js"></script>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                body {
                    margin: 0;
                    padding: 0;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    background: #1c2129;
                    color: #ffffff;
                }
                api-sports-widget {
                    width: 100%;
                    display: block;
                }
            </style>
        </head>
        <body>
            <api-sports-widget
                data-type="config"
                data-key="\(apiKey)"
                data-sport="football"
                data-theme="dark"
                data-show-logos="true"
                data-lang="es"
                data-show-errors="true"
            ></api-sports-widget>
            
            <api-sports-widget
                data-type="games"
                data-team="\(mexicoTeamId)"
                data-tab="all"
                data-update="20"
                data-show-toolbar="true"
                data-games-style="2"
                data-target-game="modal"
            ></api-sports-widget>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

// MARK: - WEBVIEW PARA WIDGETS
struct WidgetWebView: UIViewRepresentable {
    let widgetType: WidgetType
    
    enum WidgetType {
        case game(fixtureId: Int)
        case standings(leagueId: Int, season: Int)
        case team(teamId: Int)
        case h2h(team1: Int, team2: Int)
        case liveGames
        case league(leagueId: Int, season: Int)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        webView.backgroundColor = UIColor(red: 0.11, green: 0.13, blue: 0.18, alpha: 1.0)
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let htmlContent = generateHTML()
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    private func generateHTML() -> String {
        let apiKey = Config.apiSportsKey
        let widgetTag: String
        
        switch widgetType {
        case .liveGames:
            widgetTag = """
            <api-sports-widget
                data-type="games"
                data-tab="live"
                data-update="20"
                data-show-toolbar="true"
                data-games-style="2"
                data-target-game="modal"
            ></api-sports-widget>
            """
            
        case .game(let fixtureId):
            widgetTag = """
            <api-sports-widget
                data-type="game"
                data-game-id="\(fixtureId)"
                data-update="20"
                data-game-tab="lineups"
            ></api-sports-widget>
            """
            
        case .standings(let leagueId, let season):
            widgetTag = """
            <api-sports-widget
                data-type="standings"
                data-league="\(leagueId)"
                data-season="\(season)"
                data-target-team="modal"
            ></api-sports-widget>
            """
            
        case .team(let teamId):
            widgetTag = """
            <api-sports-widget
                data-type="team"
                data-team-id="\(teamId)"
                data-team-statistics="true"
                data-squad="true"
            ></api-sports-widget>
            """
            
        case .h2h(let team1, let team2):
            widgetTag = """
            <api-sports-widget
                data-type="h2h"
                data-h2h="\(team1)-\(team2)"
            ></api-sports-widget>
            """
            
        case .league(let leagueId, let season):
            widgetTag = """
            <api-sports-widget
                data-type="league"
                data-league="\(leagueId)"
                data-season="\(season)"
                data-tab="today"
                data-standings="true"
                data-target-game="modal"
            ></api-sports-widget>
            """
        }
        
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <script type="module" src="https://widgets.api-sports.io/3.1.0/widgets.js"></script>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                body {
                    margin: 0;
                    padding: 0;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    background: #1c2129;
                    color: #ffffff;
                }
                api-sports-widget {
                    width: 100%;
                    display: block;
                }
            </style>
        </head>
        <body>
            <api-sports-widget
                data-type="config"
                data-key="\(apiKey)"
                data-sport="football"
                data-theme="dark"
                data-show-logos="true"
                data-lang="es"
                data-show-errors="true"
            ></api-sports-widget>
            
            \(widgetTag)
        </body>
        </html>
        """
    }
}

// MARK: - VIEWMODEL DETALLE
class PaisDetailViewModel: ObservableObject {
    @Published var fixtures: [Fixture] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiKey = Config.apiSportsKey
    private let baseURL = "https://v3.football.api-sports.io"
    
    func loadData(teamId: Int) {
        Task {
            await loadFixtures(teamId: teamId)
        }
    }
    
    func loadFixtures(teamId: Int) async {
        await MainActor.run { isLoading = true }
        
        let headers = [
            "x-rapidapi-host": "v3.football.api-sports.io",
            "x-rapidapi-key": apiKey
        ]
        
        let url = "\(baseURL)/fixtures?team=\(teamId)&last=5"
        
        guard let requestURL = URL(string: url) else { return }
        var request = URLRequest(url: requestURL)
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(FixtureResponse.self, from: data)
            
            await MainActor.run {
                self.fixtures = response.response
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}

// MARK: - WIDGET DE CLASIFICACIÓN CONCACAF
struct ClasificacionConcacafView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = true
        webView.backgroundColor = UIColor(red: 0.11, green: 0.13, blue: 0.18, alpha: 1.0)
        webView.isOpaque = false
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let apiKey = Config.apiSportsKey
        let concacafLeagueId = 34
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <script type="module" src="https://widgets.api-sports.io/3.1.0/widgets.js"></script>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                body {
                    margin: 0;
                    padding: 0;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    background: #1c2129;
                    color: #ffffff;
                }
                api-sports-widget {
                    width: 100%;
                    display: block;
                }
            </style>
        </head>
        <body>
            <api-sports-widget
                data-type="config"
                data-key="\(apiKey)"
                data-sport="football"
                data-theme="dark"
                data-show-logos="true"
                data-lang="es"
                data-show-errors="true"
            ></api-sports-widget>
            
            <api-sports-widget
                data-type="standings"
                data-league="\(concacafLeagueId)"
                data-season="\(currentYear)"
                data-target-team="modal"
            ></api-sports-widget>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

// MARK: - PREVIEW
#Preview {
    TablaGeneralView(equipos: [])
}
