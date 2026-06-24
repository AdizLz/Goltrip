//
//  StadiumDetailView.swift
//  worldcup
//
//  Created by Ase on 15/10/25.
//

import SwiftUI

struct StadiumDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedCategory: StadiumCategory?
    @State private var showMapa3D = false
    
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.11, blue: 0.17)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Estadio BBVA Bancomer")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                            .background(Color(red: 0.2, green: 0.23, blue: 0.3))
                            .clipShape(Circle())
                    }
                }
                .padding()
                
                Text("Monterrey · Capacidad: 51,348")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.67))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                // Categories Horizontal Scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        CategoryButton(icon: "person.fill", title: "Asientos", isSelected: selectedCategory == .asientos) {
                            selectedCategory = .asientos
                        }
                        CategoryButton(icon: "fork.knife", title: "Restaurantes", isSelected: selectedCategory == .restaurantes) {
                            selectedCategory = .restaurantes
                        }
                        CategoryButton(icon: "bag.fill", title: "Tiendas", isSelected: selectedCategory == .tiendas) {
                            selectedCategory = .tiendas
                        }
                        CategoryButton(icon: "mappin", title: "Zonas", isSelected: selectedCategory == .zonas) {
                            selectedCategory = .zonas
                        }
                        CategoryButton(icon: "figure.stand", title: "Baños", isSelected: selectedCategory == .baños) {
                            selectedCategory = .baños
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Stadium Map Placeholder
                        VStack(spacing: 20) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                                    .frame(height: 250)
                                
                                VStack(spacing: 16) {
                                    Image(systemName: "building.2.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.blue)
                                    
                                    Text("Mapa del Estadio BBVA")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Vista interactiva del estadio")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.67))
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Info Text
                        Text("Aquí se mostrará el mapa interactivo del estadio con todas las ubicaciones de asientos, restaurantes, tiendas, baños y zonas especiales.")
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.67))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 20)
                        
                        // Grid Buttons
                        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 20) {
                            GridButton(icon: "person.fill", title: "Asientos") {
                                selectedCategory = .asientos
                            }
                            GridButton(icon: "fork.knife", title: "Restaurantes") {
                                selectedCategory = .restaurantes
                            }
                            GridButton(icon: "bag.fill", title: "Tiendas") {
                                selectedCategory = .tiendas
                            }
                            GridButton(icon: "mappin", title: "Zonas") {
                                selectedCategory = .zonas
                            }
                            GridButton(icon: "figure.stand", title: "Baños") {
                                selectedCategory = .baños
                            }
                            GridButton(icon: "parkingsign", title: "Estacionamiento") {
                                selectedCategory = .estacionamiento
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryDetailView(category: category)
        }
    }
}

enum StadiumCategory: Identifiable {
    case asientos, restaurantes, tiendas, zonas, baños, estacionamiento
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .asientos: return "Asientos"
        case .restaurantes: return "Restaurantes"
        case .tiendas: return "Tiendas"
        case .zonas: return "Zonas"
        case .baños: return "Baños"
        case .estacionamiento: return "Estacionamiento"
        }
    }
    
    var icon: String {
        switch self {
        case .asientos: return "person.fill"
        case .restaurantes: return "fork.knife"
        case .tiendas: return "bag.fill"
        case .zonas: return "mappin"
        case .baños: return "figure.stand"
        case .estacionamiento: return "parkingsign"
        }
    }
}

struct CategoryButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    init(icon: String, title: String, isSelected: Bool = false, action: @escaping () -> Void = {}) {
        self.icon = icon
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.white)
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.blue : Color(red: 0.2, green: 0.23, blue: 0.3))
            .cornerRadius(20)
        }
    }
}

struct GridButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    init(icon: String, title: String, action: @escaping () -> Void = {}) {
        self.icon = icon
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color(red: 0.15, green: 0.17, blue: 0.22))
            .cornerRadius(16)
        }
    }
}

struct CategoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    let category: StadiumCategory
    
    var body: some View {
        ZStack {
            Color(red: 0.09, green: 0.11, blue: 0.17)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                        
                        Text(category.title)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 36, height: 36)
                            .background(Color(red: 0.2, green: 0.23, blue: 0.3))
                            .clipShape(Circle())
                    }
                }
                .padding()
                .background(Color(red: 0.15, green: 0.17, blue: 0.22))
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Map Preview
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.15, green: 0.17, blue: 0.22))
                                .frame(height: 300)
                            
                            VStack(spacing: 16) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)
                                
                                Text("Mapa de \(category.title)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Ubicaciones en el estadio")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.67))
                            }
                        }
                        .padding()
                        
                        // List of locations (placeholder)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Ubicaciones disponibles")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ForEach(1...5, id: \.self) { index in
                                LocationCard(
                                    name: "\(category.title) \(index)",
                                    location: "Nivel \(index % 3 + 1)",
                                    icon: category.icon
                                )
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct LocationCard: View {
    let name: String
    let location: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 50, height: 50)
                .background(Color(red: 0.18, green: 0.25, blue: 0.38))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(location)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.67))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(red: 0.6, green: 0.62, blue: 0.67))
        }
        .padding()
        .background(Color(red: 0.15, green: 0.17, blue: 0.22))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct StadiumDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StadiumDetailView()
    }
}
