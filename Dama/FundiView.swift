import SwiftUI

struct FundiView: View {
    @State private var isFavorite = false
    @State private var currentPage = 0
    
    let images = ["fundi2","fundi1", "fundi3", "fundi4"]
    
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
                            Text("Parque Fundidora")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Parque público urbano")
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
                                
                                Text("Abierto todos los días de 6:00 a 22:00 h")
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
                                
                                Text("Sin costo de entrada.")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                Text("Estacionamiento: $25 MXN por hora o $100-150 MXN todo el día")
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
                                Text("Information")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Parque Fundidora es uno de los lugares más emblemáticos y representativos de Monterrey, Nuevo León. Se trata de un enorme parque público urbano construido sobre los terrenos de la antigua Compañía Fundidora de Fierro y Acero de Monterrey. Después de su cierre, el sitio fue transformado en un espacio recreativo, cultural e histórico, conservando buena parte de su infraestructura industrial original.")
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
                                ServiceItem(icon: "tree.fill", label: "Areas Verdes")
                                ServiceItem(icon: "figure.walk", label: "Paseos")
                                ServiceItem(icon: "figure.dance", label: "Exposiciones")
                                ServiceItem(icon: "figure.outdoor.cycle", label: "Bicis")
                                
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
                
                // Botón fijo en la parte inferior
                VStack {
                    
                    Button(action: {
                        let address = "Av. Fundidora y Adolfo Prieto S/N, Col. Obrera, Monterrey, Nuevo León."
                        
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
                            .background(Color(red: 0.3, green: 0.35, blue: 0.9))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Vista para items del carrusel
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
    
    // Vista para botón de favorito
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
    
    // Vista para items de servicios
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
    
    // Vista para botones de redes sociales
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
// Preview
struct FundiView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FundiView()
        }
    }
}
