import SwiftUI

struct LoginView: View {
    @Binding var selectedLanguageIdentifier: String
    @Binding var hasCompletedLogin: Bool
    
    var isLanguageSelected: Bool {
            !selectedLanguageIdentifier.isEmpty
        }
    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.07, green: 0.09, blue: 0.14),
                    Color(red: 0.05, green: 0.13, blue: 0.25),
                    Color(red: 0.07, green: 0.09, blue: 0.14)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo y contenido principal
                VStack {
                    // Logo del Mundial
                    Image("LogoApp")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                        
                    
                    // 3. Usa llaves de localización
                                        Text("login.subtitle")
                                            .font(.system(size: 18, weight: .regular))
                                            .foregroundColor(Color(white: 0.7))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 30)
                    
                    // Selector de idioma
                    VStack(spacing: 15) {
                        Text("login.select_language")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(Color(white: 0.5))
                        
                        HStack(spacing: 15) {
                            // 4. Botones actualizan el Binding<String>
                                                        LanguageButton(
                                                            flag: "🇲🇽", // Cambiado a bandera de México
                                                            language: "Español",
                                                            isSelected: selectedLanguageIdentifier == "es",
                                                            action: { selectedLanguageIdentifier = "es" }
                                                        )
                                                        LanguageButton(
                                                            flag: "🇺🇸",
                                                            language: "English",
                                                            isSelected: selectedLanguageIdentifier == "en",
                                                            action: { selectedLanguageIdentifier = "en" }
                                                        )
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
                
                // Botón de continuar y footer
                VStack(spacing: 15) {
                    Button(action: {
                        if isLanguageSelected {
                            handleContinue()
                        }
                    }) {
                        Text("login.continue_button")                         .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background {
                                if isLanguageSelected {
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.18, green: 0.48, blue: 0.31),
                                            Color(red: 0.16, green: 0.42, blue: 0.27)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(white: 0.3),
                                            Color(white: 0.3)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                            .cornerRadius(28)
                            .shadow(color: isLanguageSelected ? Color.green.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 4)
                    }
                    .disabled(selectedLanguageIdentifier.isEmpty)
                    .opacity(isLanguageSelected ? 1 : 0.5)
                    .padding(.horizontal, 30)
                    
                    // Mundial 2026 y banderas
                    VStack(spacing: 10) {
                        Text("Mundial 2026")
                            .font(.system(size: 14))
                            .foregroundColor(Color(white: 0.4))
                        
                        HStack(spacing: 25) {
                            Text("🇺🇸").font(.system(size: 40))
                            Text("🇨🇦").font(.system(size: 40))
                            Text("🇲🇽").font(.system(size: 40))
                        }
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    func handleContinue() {
            print("Continuando con idioma: \(selectedLanguageIdentifier)")
            withAnimation {
                hasCompletedLogin = true // Esto le dice a worldcupApp que cambie de vista
            }
        }
}

// Componente para el botón de idioma
struct LanguageButton: View {
    let flag: String
    let language: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(flag)
                    .font(.system(size: 30))
                Text(language)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                isSelected ?
                Color(red: 0.18, green: 0.48, blue: 0.31) :
                Color(white: 0.15)
            )
            .cornerRadius(16)
            .shadow(
                color: isSelected ? Color.green.opacity(0.4) : Color.clear,
                radius: 12,
                x: 0,
                y: 4
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
    }
}

#Preview {
    LoginView(
            selectedLanguageIdentifier: .constant("es"),
            hasCompletedLogin: .constant(false)
        )
}
