import SwiftUI

struct Alineaciones: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.15).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Back Button Header
                        HStack {
                            NavigationLink(destination: EstadioView()) {
            
                                }
                                .foregroundColor(.cyan)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        // Header
                        VStack(spacing: 8) {
                            HStack {
                                Image(systemName: "globe")
                                Text("World: World Cup")
                                Spacer()
                                Text("Quarter-finals")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.12, blue: 0.18))
                        .cornerRadius(12)
                        
                        // Match Score Card
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                // Mexico
                                VStack(alignment: .center, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.yellow)
                                        Text("Mexico")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    
                                    FlagView(colors: [Color(red: 0, green: 0.5, blue: 0), .white, Color(red: 0.8, green: 0, blue: 0)])
                                        .frame(height: 40)
                                }
                                
                                // Score
                                VStack(spacing: 4) {
                                    Text("1 - 2")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("FINISHED")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.green)
                                }
                                
                                // Portugal
                                VStack(alignment: .center, spacing: 8) {
                                    HStack(spacing: 4) {
                                        Text("Portugal")
                                            .font(.system(size: 16, weight: .semibold))
                                        Image(systemName: "star")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                    .foregroundColor(.white)
                                    
                                    FlagView(colors: [Color(red: 0, green: 0.3, blue: 0.7), Color(red: 0.9, green: 0.7, blue: 0)])
                                        .frame(height: 40)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                            Divider()
                                .background(Color.gray.opacity(0.3))
                            
                            // Match Info
                            VStack(spacing: 6) {
                                HStack(spacing: 8) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    Text("Wilton Pereira Sampaio")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    Text("Al Bayt Stadium")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 12))
                                        .foregroundColor(.blue)
                                    Text("10.12.2022 • 20:00")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                        
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.12, blue: 0.18))
                        .cornerRadius(12)
                        
                        // Field Visualization
                        VStack {
                            FieldView()
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.12, blue: 0.18))
                        .cornerRadius(12)
                        
                        // Coaches
                        VStack(spacing: 12) {
                            Text("COACHES")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text("G. Martino")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("F. Santos")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.12, blue: 0.18))
                        .cornerRadius(12)
                        
                        // Formations
                        VStack(spacing: 12) {
                            Text("FORMATIONS")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text("4-3-3")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                Spacer()
                                Text("4-2-3-1")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color(red: 0.12, green: 0.12, blue: 0.18))
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
    }


struct FlagView: View {
    let colors: [Color]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(colors.indices, id: \.self) { index in
                colors[index]
                    .frame(maxWidth: .infinity)
            }
        }
        .cornerRadius(4)
    }
}

struct FieldView: View {
    var body: some View {
        VStack {
            ZStack {
                // Field
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.2, green: 0.5, blue: 0.2))
                
                // Field lines
                VStack {
                    HStack {
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 1)
                            Spacer()
                        }
                        Spacer()
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 1)
                        Spacer()
                    }
                }
                
                // Players
                VStack {
                    HStack {
                        // Mexico XI (left side)
                        VStack(spacing: 8) {
                            ForEach(0..<4, id: \.self) { row in
                                HStack(spacing: 12) {
                                    ForEach(0..<(row == 2 ? 3 : 2), id: \.self) { _ in
                                        PlayerCircle(number: Int.random(in: 1...11), team: "mex")
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Portugal XI (right side)
                        VStack(spacing: 8) {
                            ForEach(0..<4, id: \.self) { row in
                                HStack(spacing: 12) {
                                    ForEach(0..<(row == 1 ? 3 : 2), id: \.self) { _ in
                                        PlayerCircle(number: Int.random(in: 1...11), team: "por")
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .frame(height: 240)
        }
    }
}

struct PlayerCircle: View {
    let number: Int
    let team: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(team == "mex" ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.15, green: 0.15, blue: 0.4))
                .frame(width: 32, height: 32)
            
            Text("\(number)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(team == "mex" ? Color(red: 0, green: 0.5, blue: 0) : Color(red: 0.9, green: 0.7, blue: 0))
        }
    }
}

#Preview {
    Alineaciones()
}
