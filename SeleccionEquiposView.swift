import SwiftUI

// MARK: - Models
struct Country: Identifiable, Hashable {
    let id = UUID()
    // La clave de localización es el nombre en español (Ej: "Estados Unidos")
    let name: String
    let flag: String
    let region: String // La clave de región (Ej: "CONCACAF")
}

// MARK: - Main View
struct SeleccionEquiposView: View {
    @State private var selectedCountries: Set<Country> = []
    @State private var searchText = ""
    @State private var activeTab = "home"
    @State private var currentScreen = "home"
    @Binding var selectedLanguageIdentifier: String
    @Binding var hasCompletedLogin: Bool // Se usa para completar el Setup ($hasCompletedSetup)

    let countries = [
        // Usamos la clave de localización como valor directo
        // CONCACAF
        Country(name: "Estados Unidos", flag: "🇺🇸", region: "CONCACAF"),
        Country(name: "México", flag: "🇲🇽", region: "CONCACAF"),
        Country(name: "Canadá", flag: "🇨🇦", region: "CONCACAF"),
        Country(name: "Costa Rica", flag: "🇨🇷", region: "CONCACAF"),
        Country(name: "Jamaica", flag: "🇯🇲", region: "CONCACAF"),
        Country(name: "Panamá", flag: "🇵🇦", region: "CONCACAF"),
        
        // CAF (África)
        Country(name: "Marruecos", flag: "🇲🇦", region: "CAF"),
        Country(name: "Senegal", flag: "🇸🇳", region: "CAF"),
        Country(name: "Costa de Marfil", flag: "🇨🇮", region: "CAF"),
        Country(name: "Egipto", flag: "🇪🇬", region: "CAF"),
        Country(name: "Túnez", flag: "🇹🇳", region: "CAF"),
        Country(name: "Sudáfrica", flag: "🇿🇦", region: "CAF"),
        Country(name: "Ghana", flag: "🇬🇭", region: "CAF"),
        Country(name: "Argelia", flag: "🇩🇿", region: "CAF"),
        Country(name: "Cabo Verde", flag: "🇨🇻", region: "CAF"),
        Country(name: "Nigeria", flag: "🇳🇬", region: "CAF"),
        
        // AFC (Asia)
        Country(name: "Japón", flag: "🇯🇵", region: "AFC"),
        Country(name: "Corea del Sur", flag: "🇰🇷", region: "AFC"),
        Country(name: "Arabia Saudita", flag: "🇸🇦", region: "AFC"),
        Country(name: "Australia", flag: "🇦🇺", region: "AFC"),
        Country(name: "Irán", flag: "🇮🇷", region: "AFC"),
        Country(name: "Uzbekistán", flag: "🇺🇿", region: "AFC"),
        Country(name: "Qatar", flag: "🇶🇦", region: "AFC"),
        Country(name: "Jordania", flag: "🇯🇴", region: "AFC"),
        Country(name: "Iraq", flag: "🇮🇶", region: "AFC"),
        
        // OFC (Oceanía)
        Country(name: "Nueva Zelanda", flag: "🇳🇿", region: "OFC"),
        
        // CONMEBOL (Sudamérica)
        Country(name: "Argentina", flag: "🇦🇷", region: "CONMEBOL"),
        Country(name: "Brasil", flag: "🇧🇷", region: "CONMEBOL"),
        Country(name: "Colombia", flag: "🇨🇴", region: "CONMEBOL"),
        Country(name: "Uruguay", flag: "🇺🇾", region: "CONMEBOL"),
        Country(name: "Ecuador", flag: "🇪🇨", region: "CONMEBOL"),
        Country(name: "Paraguay", flag: "🇵🇾", region: "CONMEBOL"),
        
        // UEFA (Europa)
        Country(name: "Inglaterra", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", region: "UEFA"),
        Country(name: "España", flag: "🇪🇸", region: "UEFA"),
        Country(name: "Francia", flag: "🇫🇷", region: "UEFA"),
        Country(name: "Alemania", flag: "🇩🇪", region: "UEFA"),
        Country(name: "Portugal", flag: "🇵🇹", region: "UEFA"),
        Country(name: "Países Bajos", flag: "🇳🇱", region: "UEFA"),
        Country(name: "Italia", flag: "🇮🇹", region: "UEFA"),
        Country(name: "Bélgica", flag: "🇧🇪", region: "UEFA"),
        Country(name: "Croacia", flag: "🇭🇷", region: "UEFA"),
        Country(name: "Suiza", flag: "🇨🇭", region: "UEFA"),
        Country(name: "Dinamarca", flag: "🇩🇰", region: "UEFA"),
        Country(name: "Suecia", flag: "🇸🇪", region: "UEFA"),
        Country(name: "Polonia", flag: "🇵🇱", region: "UEFA"),
        Country(name: "Turquía", flag: "🇹🇷", region: "UEFA"),
        Country(name: "República Checa", flag: "🇨🇿", region: "UEFA"),
        Country(name: "Serbia", flag: "🇷🇸", region: "UEFA"),
    ]
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            // Se filtra por el valor de la clave de localización (ej: "Estados Unidos")
            return countries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        return NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.11, green: 0.11, blue: 0.13),
                        Color(red: 0.12, green: 0.13, blue: 0.16),
                        Color(red: 0.11, green: 0.11, blue: 0.13)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Spacer()
                            // Localización: Usamos Text("setup.skip")
                            Button(LocalizedStringKey("setup.skip")) {
                                hasCompletedLogin = true // Finaliza el setup
                            }
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                        }
                        
                        // Localización: Usamos Text("setup.title")
                        Text(LocalizedStringKey("setup.title"))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Localización: Usamos 'login.subtitle'
                        Text(LocalizedStringKey("login.subtitle"))
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            // Localización: Usamos 'setup.search_placeholder' (asumiendo que existe)
                            TextField(LocalizedStringKey("setup.search_placeholder"), text: $searchText)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(white: 0.15))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(white: 0.11).opacity(0.8))
                    
                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            if searchText.isEmpty {
                                // Recorremos los nombres de las regiones (que son las claves de localización)
                                ForEach(["CONCACAF", "CONMEBOL", "UEFA", "AFC", "CAF", "OFC"], id: \.self) { regionName in
                                    let regionCountries = countries.filter { $0.region == regionName }
                                    if !regionCountries.isEmpty {
                                        RegionSection(
                                            // Pasamos la clave directamente para que RegionSection la localice
                                            title: regionName,
                                            countries: regionCountries,
                                            selectedCountries: $selectedCountries
                                        )
                                    }
                                }
                            } else {
                                if !filteredCountries.isEmpty {
                                    // Localización: "setup.search_results"
                                    Text(LocalizedStringKey("setup.search_results"))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    
                                    CountryGrid(
                                        countries: filteredCountries,
                                        selectedCountries: $selectedCountries
                                    )
                                    .padding(.horizontal)
                                } else {
                                    VStack {
                                        Spacer()
                                        // Localización: "setup.no_teams"
                                        Text(LocalizedStringKey("setup.no_teams"))
                                            .foregroundColor(.gray)
                                            .padding(.top, 60)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.bottom, 100)
                    }
                }
                
                // Continue Button
                VStack {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        // CORRECCIÓN DE SINTAXIS DEL BOTÓN: { acción } label: { etiqueta }
                        Button(action: {
                            // Acción para continuar: Finaliza el setup
                            hasCompletedLogin = true
                        }) { // <--- Cierre de la acción
                            // Localización: "login.continue_button"
                            Text(LocalizedStringKey("login.continue_button"))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background {
                                    if selectedCountries.isEmpty {
                                        Color.gray.opacity(0.5)
                                    } else {
                                        LinearGradient(
                                            colors: [Color.blue, Color(red: 0.3, green: 0.5, blue: 0.9)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    }
                                }
                                .cornerRadius(12)
                                .shadow(color: selectedCountries.isEmpty ? .clear : .blue.opacity(0.3), radius: 10)
                        } // <--- Cierre de la etiqueta del botón (ya estaba bien)
                        .disabled(selectedCountries.isEmpty)
                        
                        if !selectedCountries.isEmpty {
                            // CORRECCIÓN: Usamos String Interpolation con LocalizedStringKey
                            Text("\(selectedCountries.count) \(LocalizedStringKey("setup.teams_selected_plural"))")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                                .transition(.opacity)
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                Color(white: 0.11),
                                Color(white: 0.11).opacity(0)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - FIFA2026App Wrapper (Se mantiene para compatibilidad con otras vistas)
struct FIFA2026AppWrapper: View {
    @Binding var activeTab: String
    @Binding var currentScreen: String
    @Binding var selectedLanguageIdentifier: String
    @Binding var hasCompletedTeamSelection: Bool

    var body: some View {
        ZStack {
            VStack {
                Text(LocalizedStringKey("FIFA 2026 App Content"))
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Spacer()
                Text(LocalizedStringKey("Bottom Tab Bar"))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Region Section
struct RegionSection: View {
    let title: String // Ahora es la CLAVE de localización (Ej: "CONCACAF")
    let countries: [Country]
    @Binding var selectedCountries: Set<Country>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Usamos LocalizedStringKey para que el String 'title' sea interpretado como clave
            Text(LocalizedStringKey(title))
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            CountryGrid(countries: countries, selectedCountries: $selectedCountries)
                .padding(.horizontal)
        }
    }
}

// MARK: - Country Grid
struct CountryGrid: View {
    let countries: [Country]
    @Binding var selectedCountries: Set<Country>
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(countries) { country in
                CountryButton(
                    country: country,
                    isSelected: selectedCountries.contains(country)
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if selectedCountries.contains(country) {
                            selectedCountries.remove(country)
                        } else {
                            selectedCountries.insert(country)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Country Button
struct CountryButton: View {
    let country: Country
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                            ? LinearGradient(
                                colors: [Color.blue, Color(red: 0.2, green: 0.4, blue: 0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [Color(white: 0.15), Color(white: 0.15)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    isSelected
                                    ? Color.blue.opacity(0.5)
                                    : Color.gray.opacity(0.3),
                                    lineWidth: isSelected ? 4 : 2
                                )
                        )
                        .shadow(
                            color: isSelected ? .blue.opacity(0.5) : .clear,
                            radius: 10
                        )
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                    
                    Text(country.flag)
                        .font(.system(size: 36))
                    
                    if isSelected {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                            .offset(x: 32, y: -32)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                // Usamos LocalizedStringKey para que el nombre del país (clave) sea traducido
                Text(LocalizedStringKey(country.name))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .blue : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 32)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}// MARK: - Preview
struct SeleccionEquiposView_Previews: PreviewProvider {
    static var previews: some View {
        SeleccionEquiposView(selectedLanguageIdentifier: .constant("es"),
                             hasCompletedLogin: .constant(false) // Necesita ambos Bindings
        )
    }
}
