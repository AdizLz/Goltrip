import SwiftUI

struct ConarteView: View {
    @State private var isFavorite = false
    @State private var currentPage = 0
    
    let images = ["conarte1","conarte2", "conarte3", "conarte4"]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Fondo claro (se quitó el fondo oscuro)
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
                            Text("CONARTE")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Consejo para la Cultura y las Artes de Nuevo León")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                        
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
                                
                                Text("Lunes a domingo de 10:00 a 18:00 h (cerrado martes).")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
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
                                
                                Text("Precios: Entrada general gratuita, excepto para funciones especiales o talleres con costo.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
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
                                
                                Text("CONARTE es el corazón cultural de Nuevo León: un conjunto de lugares y actividades donde puedes disfrutar del arte, aprender, ver espectáculos o simplemente pasar un rato agradable descubriendo la cultura local.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .lineSpacing(4)
                            }
                        }
                        
                        Divider()
                        
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
                                ServiceItem(icon: "movieclapper.fill", label: "Cine")
                                ServiceItem(icon: "pencil.and.outline", label: "Talleres")
                                ServiceItem(icon: "figure.2", label: "Visitas guiadas")
                                ServiceItem(icon: "book.closed.fill", label: "Librerías")
                                ServiceItem(icon: "theatermasks.fill", label: "Teatro")
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
                        let address = "Parque Fundidora, Av. Fundidora y Adolfo Prieto S/N, Col. Obrera, Monterrey, Nuevo León, C.P. 64010"
                        
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
                    .background(Color.black.opacity(0.3))
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
                    .foregroundColor(.white)
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
            }
        }
    }
}

struct CulturaView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConarteView()
        }
    }
}
