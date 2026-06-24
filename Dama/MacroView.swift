//
//  MacroView.swift
//  HackmUJERES
//
//  Created by Damaris B on 14/10/25.
//

import SwiftUI

struct MacroView: View {
    @State private var isFavorite = false
    @State private var currentPage = 0
    
    let images = ["macro1","macro2", "macro3", "macro4"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.09, green: 0.11, blue: 0.17) // azul oscuro elegante
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Carrusel de imágenes
                    ZStack(alignment: .topLeading) {
                        TabView(selection: $currentPage) {
                            ForEach(0..<images.count, id: \.self) { index in
                                ImageCarouselItem(imageName: images[index])
                                    .tag(index)
                            }
                        }
                        .frame(height: 220)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        
                        // Botón de favorito
                        FavoriteButton(isFavorite: $isFavorite)
                            .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        // Título y subtítulo
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Macroplaza")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Consejo para la Cultura y las Artes de Nuevo León")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        // Schedule
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "clock")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Horarios")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Accesible todos los días del año, las 24 horas")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        // General admission
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "eurosign.circle")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Costos")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Gratuito")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        // Information
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "info.circle")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Información")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("La Macroplaza de Monterrey es uno de los espacios públicos más emblemáticos de la ciudad. Está situada en el centro de Monterrey y se dice que es una de las plazas públicas más grandes del mundo.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .lineSpacing(4)
                            }
                        }
                        
                        Divider().background(Color.white.opacity(0.2))
                        
                        // Services
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.grid.2x2")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .frame(width: 24)
                                
                                Text("Servicios")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 24) {
                                ServiceItem(icon: "tree.fill", label: "Areas Verdes")
                                ServiceItem(icon: "theatermask.and.paintbrush.fill", label: "Museos")
                                
                            }
                            .padding(.leading, 20)
                        }
                        
                        Divider()
                        
                        // Follow us
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "globe")
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .frame(width: 24)
                                
                                Text("Redes Sociales:")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 20) {
                                SocialButton(icon: "xmark", label: "X")
                                SocialButton(icon: "camera", label: "Instagram")
                                SocialButton(icon: "play.rectangle.fill", label: "YouTube")
                            }
                            .padding(.leading, 36)
                        }
                    }
                    .padding(20)
                }
                
                // Botón inferior
                VStack {
                    Button(action: {
                        let address = "Av. Ignacio Zaragoza Sur, Zona Centro, Monterrey, 64000, Nuevo León, México"
                        
                        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        if let url = URL(string: "http://maps.apple.com/?address=\(encodedAddress)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("¡Vamos!")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(red: 0.2, green: 0.1, blue: 0.4))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Subvistas
    struct ImageCarouselItem: View {
        let imageName: String
        var body: some View {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()
        }
    }
    
    struct FavoriteButton: View {
        @Binding var isFavorite: Bool
        var body: some View {
            Button(action: { isFavorite.toggle() }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(isFavorite ? .red : .white)
                    .padding(12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }
    
    struct ServiceItem: View {
        let icon: String
        let label: String
        var body: some View {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
            }
        }
    }
    
    struct SocialButton: View {
        let icon: String
        let label: String
        var body: some View {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
            }
        }
    }
}

struct MacroView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MacroView()
        }
    }
}
