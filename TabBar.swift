import Foundation
import SwiftUI


struct BottomTabBar: View {
    @Binding var activeTab: String
    @Binding var currentScreen: String
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(icon: "house.fill", title: "Home", isActive: activeTab == "home") {
                activeTab = "home"
                currentScreen = "home"
            }
            
            TabButton(icon: "sparkles", title: "Cultura", isActive: activeTab == "cultural") {
                activeTab = "cultural"
                currentScreen = "cultural"
            }
            
            TabButton(icon: "sportscourt.fill", title: "Estadio", isActive: activeTab == "stadium") {
                activeTab = "stadium"
                currentScreen = "stadium"
            }
            
            TabButton(icon: "map.fill", title: "Mapa", isActive: activeTab == "map") {
                activeTab = "map"
                currentScreen = "map"
            }
            
            TabButton(icon: "message.circle.fill", title: "FIFABot", isActive: activeTab == "fifabot") {
                activeTab = "fifabot"
                currentScreen = "fifabot"
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.theme.cardBackground.opacity(0.95))
        .overlay(
            Rectangle()
                .fill(Color.theme.secondaryAccent.opacity(0.3))
                .frame(height: 1),
            alignment: .top
        )
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .padding(8)
                    .background(isActive ? Color.theme.primaryAccent.opacity(0.2) : Color.clear)
                    .cornerRadius(12)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(isActive ? Color.theme.primaryAccent : Color.theme.secondaryText)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
