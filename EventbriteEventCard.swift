import SwiftUI

// MARK: - Eventbrite Event Card
struct EventbriteEventCard: View {
     let event: EventbriteEvent
     let action: () -> Void
    
     // Helper para formatear fecha
     var formattedStartDate: String {
         if let date = event.start?.localDate {
             return date.formatted(date: .abbreviated, time: .shortened)
         }
         return String(localized: "eb.no_date") // Llave de Localizable.strings
     }
    
     var body: some View {
         Button(action: action) {
             HStack(spacing: 16) {
                 // Placeholder para la imagen (cargar imágenes de URL es más complejo)
                 RoundedRectangle(cornerRadius: 12)
                     .fill(Color.theme.secondaryText.opacity(0.3))
                     .frame(width: 64, height: 64)
                     .overlay(Image(systemName: "ticket").foregroundColor(Color.theme.primaryText))
                 
                 VStack(alignment: .leading, spacing: 6) {
                     Text(event.name?.text ?? String(localized: "eb.no_title")) // Título del evento
                         .font(.headline)
                         .fontWeight(.bold)
                         .lineLimit(2)
                     
                     HStack(spacing: 4) { // Fecha
                         Image(systemName: "calendar")
                         Text(formattedStartDate)
                     }.font(.caption)
                     
                     // Lugar (Venue)
                     if let venueName = event.venue?.name {
                         HStack(spacing: 4) {
                             Image(systemName: "mappin.circle.fill").foregroundColor(.red)
                             Text(venueName)
                         }.font(.caption).lineLimit(1)
                     } else if let address = event.venue?.address?.displayAddress, !address.isEmpty {
                         // Fallback a la dirección si no hay nombre de lugar
                         HStack(spacing: 4) {
                             Image(systemName: "mappin").foregroundColor(.red)
                             Text(address)
                         }.font(.caption).lineLimit(1)
                     }
                 }.foregroundColor(Color.theme.secondaryText)
                 
                 Spacer()
                 
                 Image(systemName: "chevron.right")
                     .foregroundColor(Color.theme.secondaryText)
             }
             .padding()
             .background(Color.theme.cardBackground)
             .cornerRadius(16)
             .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
         }
         .buttonStyle(PlainButtonStyle())
         .foregroundColor(Color.theme.primaryText)
     }
}
