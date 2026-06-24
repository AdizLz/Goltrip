//
//  CultureView.swift
//  worldcup
//
//  Created by Damaris B on 15/10/25.
//

import SwiftUI

struct CultureView: View {
    @State private var currentIndex = 0
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var selectedSort: SortOption = .distance
    @Binding var selectedLanguageIdentifier: String
    @Binding var modoApariencia: ModoApariencia
    
    // ▼▼▼ ENUM MODIFICADO PARA LOCALIZACIÓN ▼▼▼
    enum SortOption: CaseIterable, Identifiable {
        case distance, category, alphabetically, price, open
        
        var id: Self { self }
        
        // Propiedad 'name' que devuelve la llave de localización
        var name: LocalizedStringKey {
            switch self {
            case .distance: return "culture.sort.distance"
            case .category: return "culture.sort.category"
            case .alphabetically: return "culture.sort.alphabetically"
            case .price: return "culture.sort.price"
            case .open: return "culture.sort.open"
            }
        }
        
        var icon: String {
            switch self {
            case .distance: return "location.fill"
            case .category: return "tag.fill"
            case .alphabetically: return "textformat"
            case .price: return "dollarsign.circle" // Cambiado de euro
            case .open: return "clock.fill"
            }
        }
    }
    // ▲▲▲ FIN ENUM MODIFICADO ▲▲▲
    
    // Array de imágenes del carousel (Los datos se quedan en español, pero el UI se traduce)
    let carouselItems = [
        CarouselItem(imageName: "marco", title: "Museo Marco", description: "El MARCO es un museo de arte contemporáneo con exposiciones innovadoras y arquitectura emblemática en Monterrey."),
        CarouselItem(imageName: "hornotres", title: "Museo del Acero Horno 3", description: "El Museo Horno 3 combina historia, ciencia e industria en un antiguo horno de acero dentro del Parque Fundidora."),
        CarouselItem(imageName: "obispi", title: "El Obispado", description: "El Obispado es un museo histórico ubicado en un antiguo palacio del siglo XVIII, con vistas panorámicas de Monterrey.")
    ]
    
    // Array de lugares adicionales (Datos en español)
    // (Asegúrate que estas Vistas de destino existan en tu proyecto)
    let places = [
        Place(imageName: "conarte", title: "CONARTE", description: "Centro de las Artes de Monterrey", distance: "273 m", destination: AnyView(ConarteView())),
        Place(imageName: "fundidora", title: "Parque Fundidora", description: "Parque urbano que además contiene espacios culturales", distance: "1.2 km", destination: AnyView(FundiView())),
        Place(imageName: "macro", title: "Macroplaza", description: "Gran plaza pública con monumentos, espacios verdes, sitios de recreo, punto central para eventos urbanos.", distance: "850 m", destination: AnyView(MacroView()))
    ]
    
    // Propiedad computada para filtrar y ordenar lugares
    var filteredPlaces: [Place] {
        var results = places
        
        if !searchText.isEmpty {
            results = results.filter { place in
                place.title.localizedCaseInsensitiveContains(searchText) ||
                place.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedSort {
        case .distance:
            results.sort { $0.distanceValue < $1.distanceValue }
        case .alphabetically:
            results.sort { $0.title < $1.title }
        case .price:
            results.sort { $0.title < $1.title } // Placeholder
        case .category, .open:
            break
        }
        
        return results
    }
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                
                // Barra de búsqueda y filtro
                HStack(spacing: 12) {
                    // Campo de búsqueda
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color.theme.secondaryText) // Adaptable
                            .font(.system(size: 18))
                        
                        TextField("search_placeholder", text: $searchText, prompt: Text("search_placeholder").foregroundColor(Color.theme.secondaryText)) // Localizado
                            .font(.system(size: 16))
                            .foregroundColor(Color.theme.primaryText) // Adaptable
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(Color.theme.secondaryText) // Adaptable
                                    .font(.system(size: 16))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.theme.cardBackground.opacity(0.5)) // Adaptable
                    .cornerRadius(25)
                    
                    // Botón de filtro
                    Button(action: {
                        showFilterSheet = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(Color.theme.primaryText) // Adaptable
                            .font(.system(size: 20))
                            .frame(width: 44, height: 44)
                            .background(Color.theme.cardBackground.opacity(0.5)) // Adaptable
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
                .background(Color.theme.mainBackground) // Fondo adaptable
                
                // ScrollView con el contenido
                ScrollView {
                    VStack(spacing: 0) {
                        // Carousel Section (solo se muestra si no hay búsqueda)
                        if searchText.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("culture.title") // Localizado
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color.theme.primaryText) // Adaptable
                                    .padding(.horizontal, 20)
                                
                                Text("culture.subtitle") // Localizado
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.theme.secondaryText) // Adaptable
                                    .padding(.horizontal, 20)
                                
                                // Carousel
                                TabView(selection: $currentIndex) {
                                    ForEach(0..<carouselItems.count, id: \.self) { index in
                                        ZStack(alignment: .bottomLeading) {
                                            Image(carouselItems[index].imageName)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 210)
                                                .clipped()
                                                .cornerRadius(16)
                                            
                                            // Overlay (se mantiene oscuro para contraste)
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.black.opacity(0.6), Color.clear]),
                                                startPoint: .bottom,
                                                endPoint: .center
                                            )
                                            .cornerRadius(16)
                                            
                                            // Texto (se mantiene blanco para contraste)
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(carouselItems[index].title)
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.white)
                                                
                                                Text(carouselItems[index].description)
                                                    .font(.system(size: 13))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(16)
                                        }
                                        .padding(.horizontal, 16)
                                        .tag(index)
                                    }
                                }
                                .frame(height: 230)
                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                            }
                            .padding(.top, 20)
                        }
                        
                        // Sección Ver más con lugares filtrados
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text(searchText.isEmpty ? "culture.see_more" : "culture.results") // Localizado
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color.theme.primaryText) // Adaptable
                                
                                Spacer()
                                
                                if !searchText.isEmpty {
                                    // Localizado con variable
                                    Text(String(format: NSLocalizedString("culture.results.count", comment: "result count"), filteredPlaces.count))
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.theme.secondaryText) // Adaptable
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, searchText.isEmpty ? 30 : 20)
                            
                            // Mostrar lugares filtrados
                            if filteredPlaces.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 50))
                                        .foregroundColor(Color.theme.secondaryText) // Adaptable
                                    
                                    Text("culture.no_results") // Localizado
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color.theme.primaryText) // Adaptable
                                    
                                    Text("culture.try_again") // Localizado
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.theme.secondaryText) // Adaptable
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 60)
                            } else {
                                ForEach(filteredPlaces) { place in
                                    ZStack(alignment: .bottomTrailing) {
                                        NewPlaceCard(place: place)
                                        NavigationLink(destination: place.destination) {
                                            HStack(spacing: 4) {
                                                Text("culture.go_button") // Localizado
                                                    .font(.system(size: 14, weight: .semibold))
                                                Image(systemName: "arrow.up.right")
                                                    .font(.system(size: 12, weight: .semibold))
                                            }
                                            .foregroundColor(Color.theme.primaryAccent) // Adaptable
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .background(Color.theme.primaryAccent.opacity(0.15)) // Adaptable
                                            .cornerRadius(20)
                                        }
                                        .padding(.trailing, 40)
                                        .padding(.bottom, 20)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }
                } // Fin ScrollView
            }
            .background(Color.theme.mainBackground.ignoresSafeArea()) // Fondo principal adaptable
            .sheet(isPresented: $showFilterSheet) {
                FilterSheet(selectedSort: $selectedSort, showFilterSheet: $showFilterSheet)
            }
        }
    }
}

// Modelo para los items del carousel
struct CarouselItem {
    let imageName: String
    let title: String
    let description: String
}

// Modelo para los lugares
struct Place: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let distance: String
    let destination: AnyView
    
    // Propiedad computada para ordenar por distancia
    var distanceValue: Double {
        let numbers = distance.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if distance.contains("km") {
            return Double(numbers) ?? 0
        } else {
            return (Double(numbers) ?? 0) / 1000
        }
    }
}

// Vista de tarjeta de lugar con nuevo diseño
struct NewPlaceCard: View {
    let place: Place
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Imagen de fondo
            Image(place.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .clipped()
                .cornerRadius(16)
            
            // Overlay oscuro (mantenido para contraste)
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                startPoint: .bottom,
                endPoint: .center
            )
            .cornerRadius(16)
            
            // Contenido de texto (mantenido blanco para contraste)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(place.description)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
                Spacer()
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
    }
}

// Vista de tarjeta de lugar antigua (No usada, pero la dejo por si acaso)
struct PlaceCard: View {
    let place: Place
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(place.imageName)
                .resizable().aspectRatio(contentMode: .fill)
                .frame(height: 220).clipped().cornerRadius(16)
            
            HStack(spacing: 4) {
                Image(systemName: "location.fill").font(.system(size: 12))
                Text(place.distance)
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(Color.purple.opacity(0.9))
            .cornerRadius(20)
            .padding(12)
        }
        .padding(.horizontal, 20)
    }
}

// Vista del Sheet de filtros
struct FilterSheet: View {
    @Binding var selectedSort: CultureView.SortOption
    @Binding var showFilterSheet: Bool
    @State private var tempSelection: CultureView.SortOption
    
    init(selectedSort: Binding<CultureView.SortOption>, showFilterSheet: Binding<Bool>) {
        self._selectedSort = selectedSort
        self._showFilterSheet = showFilterSheet
        self._tempSelection = State(initialValue: selectedSort.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 32))
                    .foregroundColor(Color.theme.primaryAccent) // Adaptable
                
                Text("culture.filter.title") // Localizado
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText) // Adaptable
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .padding(.bottom, 30)
            
            // Opciones de filtro
            VStack(spacing: 0) {
                ForEach(CultureView.SortOption.allCases, id: \.id) { option in
                    Button(action: {
                        tempSelection = option
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: option.icon)
                                .font(.system(size: 22))
                                .foregroundColor(Color.theme.secondaryText) // Adaptable
                                .frame(width: 30)
                            
                            Text(option.name) // Usa .name (localizado)
                                .font(.system(size: 18))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            if tempSelection == option {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(Color.theme.primaryAccent) // Adaptable
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                    }
                    
                    if option != CultureView.SortOption.allCases.last {
                        Divider()
                            .background(Color.theme.secondaryText.opacity(0.3)) // Adaptable
                            .padding(.leading, 76)
                    }
                }
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            // Botones de acción
            VStack(spacing: 16) {
                Button(action: {
                    selectedSort = tempSelection
                    showFilterSheet = false
                }) {
                    Text("culture.filter.order_button") // Localizado
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white) // Texto blanco para contraste
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.theme.primaryAccent) // Adaptable
                        .cornerRadius(12)
                }
                
                Button(action: {
                    showFilterSheet = false
                }) {
                    Text("culture.filter.cancel_button") // Localizado
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.theme.secondaryText) // Adaptable
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
        .background(Color.theme.mainBackground.ignoresSafeArea()) // Fondo adaptable
        .foregroundColor(Color.theme.primaryText) // Color de texto por defecto
    }
}



// MARK: - Preview
struct CultureView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Vista previa en Español (Modo Oscuro)
        CultureView(selectedLanguageIdentifier: .constant("es"),modoApariencia: .constant(.oscuro))
            .environment(\.locale, .init(identifier: "en"))
            .preferredColorScheme(.dark)
    }
}
