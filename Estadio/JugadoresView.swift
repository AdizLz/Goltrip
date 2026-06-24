import SwiftUI

// MARK: - Models
struct Player: Identifiable, Codable {
    let id: Int
    let name: String
    let firstname: String?
    let lastname: String?
    let age: Int?
    let nationality: String?
    let height: String?
    let weight: String?
    let photo: String?
    
    var displayName: String {
        name
    }
}

struct PlayerStatistics: Codable {
    let team: TeamInfo?
    let games: GameStats?
    
    struct TeamInfo: Codable {
        let name: String?
        let logo: String?
    }
    
    struct GameStats: Codable {
        let position: String?
        let rating: String?
    }
}

struct PlayerResponse: Identifiable, Codable {
    var id: Int { player.id }
    let player: Player
    let statistics: [PlayerStatistics]
    let position: String? // Para mostrar la posición del squad
}

struct APIResponse: Codable {
    let response: [PlayerResponse]
}

struct Countries: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String
    let teamId: Int
}

// MARK: - API Service
class APIService {
    static let shared = APIService()
    private let apiKey = Config.apiSportsKey
    private let baseURL = "https://v3.football.api-sports.io"
    
    func fetchPlayers(teamId: Int) async throws -> [PlayerResponse] {
        let urlString = "\(baseURL)/players/squads?team=\(teamId)"
        print("🔗 Requesting: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-apisports-key")
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print(" Status: \(httpResponse.statusCode)")
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
        }
        
        let squadResponse = try JSONDecoder().decode(SquadAPIResponse.self, from: data)
        
        let players = squadResponse.response.first?.players.map { player in
            PlayerResponse(
                player: Player(
                    id: player.id,
                    name: player.name,
                    firstname: nil,
                    lastname: nil,
                    age: player.age,
                    nationality: nil,
                    height: nil,
                    weight: nil,
                    photo: player.photo
                ),
                statistics: [],
                position: player.position
            )
        } ?? []
        
        print("✅ Loaded \(players.count) players")
        return players
    }
    
    func fetchPlayerDetails(playerId: Int, season: Int = 2024) async throws -> PlayerDetailResponse {
        let urlString = "\(baseURL)/players?id=\(playerId)&season=\(season)"
        print("🔗 Fetching player details: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-apisports-key")
        request.timeoutInterval = 30
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 Player Details Status: \(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let errorString = String(data: data, encoding: .utf8) {
                    print("Error response: \(errorString)")
                }
                throw URLError(.badServerResponse)
            }
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📄 Player Details Response: \(jsonString.prefix(300))...")
        }
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(PlayerDetailAPIResponse.self, from: data)
        
        guard let playerDetail = apiResponse.response.first else {
            print("⚠️ No player data found in response")
            throw NSError(
                domain: "PlayerError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "No se encontró información del jugador para la temporada \(season)"]
            )
        }
        
        print("Player details loaded successfully")
        return playerDetail
    }
}

struct SquadAPIResponse: Codable {
    let response: [SquadResponse]
}

struct SquadResponse: Codable {
    let team: SquadTeam
    let players: [SquadPlayer]
}

struct SquadTeam: Codable {
    let id: Int
    let name: String
    let logo: String
}

struct SquadPlayer: Codable {
    let id: Int
    let name: String
    let age: Int?
    let number: Int?
    let position: String
    let photo: String
}

// MARK: - Player Detail Models
struct PlayerDetailAPIResponse: Codable {
    let response: [PlayerDetailResponse]
}

struct PlayerDetailResponse: Codable {
    let player: PlayerInfo
    let statistics: [PlayerSeasonStats]
}

struct PlayerInfo: Codable {
    let id: Int
    let name: String
    let firstname: String?
    let lastname: String?
    let age: Int?
    let birth: Birth?
    let nationality: String?
    let height: String?
    let weight: String?
    let photo: String?
    
    struct Birth: Codable {
        let date: String?
        let place: String?
        let Countries: String?
    }
}

struct PlayerSeasonStats: Codable {
    let team: TeamDetail?
    let league: LeagueDetail?
    let games: GameDetail?
    let goals: GoalDetail?
    let passes: PassDetail?
    let tackles: TackleDetail?
    let duels: DuelDetail?
    let shots: ShotDetail?
    let cards: CardDetail?
    
    struct TeamDetail: Codable {
        let id: Int?
        let name: String?
        let logo: String?
    }
    
    struct LeagueDetail: Codable {
        let id: Int?
        let name: String?
        let Countries: String?
        let logo: String?
        let flag: String?
        let season: Int?
    }
    
    struct GameDetail: Codable {
        let appearences: Int?
        let lineups: Int?
        let minutes: Int?
        let number: Int?
        let position: String?
        let rating: String?
        let captain: Bool?
    }
    
    struct GoalDetail: Codable {
        let total: Int?
        let assists: Int?
    }
    
    struct PassDetail: Codable {
        let total: Int?
        let key: Int?
        let accuracy: Int?
    }
    
    struct TackleDetail: Codable {
        let total: Int?
        let blocks: Int?
        let interceptions: Int?
    }
    
    struct DuelDetail: Codable {
        let total: Int?
        let won: Int?
    }
    
    struct ShotDetail: Codable {
        let total: Int?
        let on: Int?
    }
    
    struct CardDetail: Codable {
        let yellow: Int?
        let red: Int?
    }
}

// MARK: - ViewModels
@MainActor
class PlayersViewModel: ObservableObject {
    @Published var players: [PlayerResponse] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadPlayers(teamId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            players = try await APIService.shared.fetchPlayers(teamId: teamId)
        } catch {
            errorMessage = "Error al cargar jugadores: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

// MARK: - Main View
struct JugadoresView: View {
    @State private var selectedCountries: Countries?
    @State private var showingCountriesPicker = false
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    let countries = [
        Countries(name: "México", code: "MX", flag: "🇲🇽", teamId: 16),
        Countries(name: "Brasil", code: "BR", flag: "🇧🇷", teamId: 6),
        Countries(name: "Argentina", code: "AR", flag: "🇦🇷", teamId: 26),
        Countries(name: "España", code: "ES", flag: "🇪🇸", teamId: 9),
        Countries(name: "Alemania", code: "DE", flag: "🇩🇪", teamId: 25),
        Countries(name: "Francia", code: "FR", flag: "🇫🇷", teamId: 2),
        Countries(name: "Italia", code: "IT", flag: "🇮🇹", teamId: 768),
        Countries(name: "Inglaterra", code: "GB", flag: "🏴", teamId: 10),
        Countries(name: "Portugal", code: "PT", flag: "🇵🇹", teamId: 27),
        Countries(name: "Países Bajos", code: "NL", flag: "🇳🇱", teamId: 1118),
        Countries(name: "Estados Unidos", code: "US", flag: "🇺🇸", teamId: 2384),
        Countries(name: "Colombia", code: "CO", flag: "🇨🇴", teamId: 8),
        Countries(name: "Uruguay", code: "UY", flag: "🇺🇾", teamId: 7),
        Countries(name: "Chile", code: "CL", flag: "🇨🇱", teamId: 2385),
        Countries(name: "Perú", code: "PE", flag: "🇵🇪", teamId: 2382)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.13, blue: 0.18)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header con botón de regreso
                    VStack(spacing: 16) {
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
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Jugadores")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Selección Nacional")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Button(action: { showingCountriesPicker = true }) {
                                HStack(spacing: 8) {
                                    Text((selectedCountries ?? countries[0]).flag)
                                        .font(.title2)
                                    
                                    Text((selectedCountries ?? countries[0]).code)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.5))
                            
                            TextField("Buscar jugador...", text: $searchText)
                                .foregroundColor(.white)
                                .accentColor(.cyan)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                        )
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                    
                    if let Countries = selectedCountries {
                        PlayersGridView(teamId: Countries.teamId, CountriesName: Countries.name, searchText: searchText)
                    } else {
                        PlayersGridView(teamId: countries[0].teamId, CountriesName: countries[0].name, searchText: searchText)
                            .onAppear {
                                selectedCountries = countries[0]
                            }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingCountriesPicker) {
                CountriesPickerView(
                    countries: countries,
                    selectedCountries: $selectedCountries,
                    isPresented: $showingCountriesPicker
                )
            }
        }
    }
}

// MARK: - Supporting Views
struct CountriesPickerView: View {
    let countries: [Countries]
    @Binding var selectedCountries: Countries?
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.11, green: 0.13, blue: 0.18)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(countries) { Countries in
                            Button(action: {
                                selectedCountries = Countries
                                isPresented = false
                            }) {
                                HStack(spacing: 16) {
                                    Text(Countries.flag)
                                        .font(.system(size: 32))
                                    
                                    Text(Countries.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    if selectedCountries?.id == Countries.id {
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

struct PlayersGridView: View {
    let teamId: Int
    let CountriesName: String
    let searchText: String
    @StateObject private var viewModel = PlayersViewModel()
    
    var filteredPlayers: [PlayerResponse] {
        if searchText.isEmpty {
            return viewModel.players
        }
        return viewModel.players.filter {
            $0.player.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                        .scaleEffect(1.5)
                    Text("Cargando jugadores...")
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text(error)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Reintentar") {
                        Task {
                            await viewModel.loadPlayers(teamId: teamId)
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.cyan.opacity(0.8))
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.players.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.3.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.3))
                    
                    Text("No se encontraron jugadores")
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(filteredPlayers) { playerResponse in
                            PlayerCardModern(playerResponse: playerResponse)
                        }
                    }
                    .padding()
                }
            }
        }
        .task(id: teamId) {
            await viewModel.loadPlayers(teamId: teamId)
        }
    }
}

struct PlayerCardModern: View {
    let playerResponse: PlayerResponse
    
    var body: some View {
        NavigationLink(destination: PlayerDetailView(playerId: playerResponse.player.id)) {
            VStack(spacing: 12) {
                AsyncImage(url: URL(string: playerResponse.player.photo ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.2, green: 0.22, blue: 0.28))
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.2, green: 0.22, blue: 0.28))
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.3))
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.cyan.opacity(0.3), lineWidth: 2)
                )
                
                VStack(spacing: 4) {
                    Text(playerResponse.player.displayName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                    
                    HStack(spacing: 8) {
                        if let age = playerResponse.player.age {
                            Text("\(age) años")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        if let position = playerResponse.position {
                            Text("•")
                                .foregroundColor(.white.opacity(0.3))
                            Text(position)
                                .font(.caption2)
                                .foregroundColor(.cyan)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cyan.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Player Detail View
struct PlayerDetailView: View {
    let playerId: Int
    @StateObject private var viewModel = PlayerDetailViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(red: 0.11, green: 0.13, blue: 0.18)
                .ignoresSafeArea()
            
            ScrollView {
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .cyan))
                            .scaleEffect(1.5)
                        
                        Text("Cargando información...")
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Error al cargar detalles")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Reintentar") {
                            Task {
                                await viewModel.loadPlayerDetails(playerId: playerId)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.cyan.opacity(0.8))
                        )
                        
                        Button("Volver") {
                            dismiss()
                        }
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.top, 100)
                } else if let detail = viewModel.playerDetail {
                    VStack(spacing: 20) {
                        PlayerHeaderView(detail: detail)
                        
                        if detail.statistics.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.3))
                                
                                Text("No hay estadísticas disponibles")
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text("Este jugador no tiene datos de la temporada actual")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.4))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                            )
                        } else {
                            ForEach(Array(detail.statistics.enumerated()), id: \.offset) { index, stat in
                                SeasonStatsView(stats: stat)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .task {
            await viewModel.loadPlayerDetails(playerId: playerId)
        }
    }
}

@MainActor
class PlayerDetailViewModel: ObservableObject {
    @Published var playerDetail: PlayerDetailResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadPlayerDetails(playerId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Intenta con 2024
            do {
                playerDetail = try await APIService.shared.fetchPlayerDetails(playerId: playerId, season: 2024)
            } catch {
                // Si falla, intenta con 2023
                print("⚠️ No data for 2024, trying 2023...")
                playerDetail = try await APIService.shared.fetchPlayerDetails(playerId: playerId, season: 2023)
            }
        } catch {
            print("❌ Error loading player details: \(error)")
            errorMessage = "No se pudo cargar la información del jugador. Puede que no tenga datos disponibles en la API."
        }
        
        isLoading = false
    }
}

struct PlayerHeaderView: View {
    let detail: PlayerDetailResponse
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: URL(string: detail.player.photo ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.cyan.opacity(0.5), lineWidth: 3))
            
            VStack(spacing: 8) {
                Text(detail.player.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    if let age = detail.player.age {
                        InfoChip(icon: "calendar", text: "\(age) años")
                    }
                    if let nationality = detail.player.nationality {
                        InfoChip(icon: "flag.fill", text: nationality)
                    }
                }
                
                HStack(spacing: 16) {
                    if let height = detail.player.height {
                        InfoChip(icon: "arrow.up.and.down", text: height)
                    }
                    if let weight = detail.player.weight {
                        InfoChip(icon: "scalemass.fill", text: weight)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(red: 0.15, green: 0.17, blue: 0.22)))
    }
}

struct InfoChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.caption)
            Text(text).font(.caption)
        }
        .foregroundColor(.cyan)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.cyan.opacity(0.15)))
    }
}

struct SeasonStatsView: View {
    let stats: PlayerSeasonStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                if let logo = stats.league?.logo {
                    AsyncImage(url: URL(string: logo)) { phase in
                        if case .success(let image) = phase {
                            image.resizable().aspectRatio(contentMode: .fit)
                        } else {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(stats.league?.name ?? "Liga")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if let season = stats.league?.season {
                        Text("Temporada \(season)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                Spacer()
            }
            
            if let games = stats.games {
                VStack(spacing: 12) {
                    if let position = games.position {
                        StatRow(label: "Posición", value: position, icon: "figure.run")
                    }
                    if let appearences = games.appearences {
                        StatRow(label: "Apariciones", value: "\(appearences)", icon: "person.fill")
                    }
                    if let minutes = games.minutes {
                        StatRow(label: "Minutos", value: "\(minutes)", icon: "clock.fill")
                    }
                }
            }
            
            if let goals = stats.goals {
                HStack(spacing: 16) {
                    if let total = goals.total {
                        StatBox(title: "Goles", value: "\(total)", color: .green)
                    }
                    if let assists = goals.assists {
                        StatBox(title: "Asistencias", value: "\(assists)", color: .blue)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.15, green: 0.17, blue: 0.22)))
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String
    var highlight: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(highlight ? .cyan : .white.opacity(0.6))
                .frame(width: 24)
            Text(label).foregroundColor(.white.opacity(0.8))
            Spacer()
            Text(value).fontWeight(.semibold).foregroundColor(highlight ? .cyan : .white)
        }
        .font(.subheadline)
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.15))
        )
    }
}

struct JugadoresView_Previews: PreviewProvider {
    static var previews: some View {
        JugadoresView()
    }
}
