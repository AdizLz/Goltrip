import SwiftUI
import MapKit // Necesario para el botón de mapa

// MARK: - Eventbrite Event Modal View
struct EventbriteEventModalView: View {
     let event: EventbriteEvent
     let onClose: () -> Void
    
     // Necesario para abrir links
     @Environment(\.openURL) var openURL

     // Helper para formatear fecha/hora
     var formattedStartDateTime: String {
         if let date = event.start?.localDate {
             // Formato más completo para el modal
             return date.formatted(.dateTime.day().month().year().hour().minute())
         }
         return String(localized: "eb.no_date")
     }
    
     // Helper para descripción (prioriza texto plano)
     var descriptionText: String {
         return event.description?.text ?? event.summary ?? String(localized: "eb.no_description")
     }

     var body: some View {
         ZStack {
             Color.black.opacity(0.85).ignoresSafeArea().onTapGesture(perform: onClose) // Fondo
             ScrollView(.vertical, showsIndicators: false) {
                 VStack(alignment: .leading, spacing: 20) {
                     // Botón Cerrar
                     HStack {
                         Spacer()
                         Button(action: onClose) {
                             Image(systemName: "xmark").font(.title3).padding(12)
                                 .background(Color.gray.opacity(0.5)).clipShape(Circle())
                                 .foregroundColor(.white)
                         }
                     }
                     // Header (Icono genérico y Título)
                     HStack(spacing: 16) {
                         ZStack {
                             RoundedRectangle(cornerRadius: 16).fill(Color.orange.opacity(0.8))
                                 .frame(width: 64, height: 64)
                             Image(systemName: "ticket.fill").font(.system(size: 30)).foregroundColor(.white)
                         }
                         VStack(alignment: .leading, spacing: 4) {
                             Text("eb.event_type").font(.caption).fontWeight(.bold).foregroundColor(Color.orange) // "EVENTO"
                             Text(event.name?.text ?? String(localized: "eb.no_title")).font(.title2).fontWeight(.bold).lineLimit(2)
                         }
                     }
                     // Detalles (Lugar, Hora, Capacidad)
                     VStack(spacing: 16) {
                         if let venueName = event.venue?.name {
                             HStack(spacing: 12) { Image(systemName: "mappin.circle.fill").foregroundColor(.red); Text(venueName) }
                         } else if let address = event.venue?.address?.displayAddress, !address.isEmpty {
                             HStack(spacing: 12) { Image(systemName: "mappin").foregroundColor(.red); Text(address) }
                         }
                         
                         HStack(spacing: 12) { Image(systemName: "calendar").foregroundColor(Color.orange); Text(formattedStartDateTime) }
                         
                         if let capacity = event.capacity, capacity > 0 {
                             VStack(alignment: .leading, spacing: 8) {
                                 Text("modal.capacity").font(.subheadline).foregroundColor(Color.theme.secondaryText)
                                 Text("\(capacity)").font(.title3).fontWeight(.bold)
                             }.frame(maxWidth: .infinity, alignment: .leading).padding().background(Color.gray.opacity(0.2)).cornerRadius(12)
                         }
                     }.foregroundColor(Color.theme.secondaryText)
                     
                     // Descripción
                     VStack(alignment: .leading, spacing: 8) {
                         Text("modal.description").font(.headline).fontWeight(.semibold)
                         Text(descriptionText).font(.subheadline).foregroundColor(Color.theme.secondaryText).lineSpacing(4)
                     }
                     
                     // Botones de Acción
                     HStack(spacing: 12) {
                         Button(action: openMapForPlace) {
                             Text("modal.map_button").fontWeight(.semibold).frame(maxWidth: .infinity).padding().background(Color.gray.opacity(0.3)).cornerRadius(12)
                         }.disabled(event.venue?.address?.displayAddress.isEmpty ?? true)
                         
                         Button(action: {
                             if let urlString = event.url, let url = URL(string: urlString) {
                                 openURL(url) // Abre el link de Eventbrite
                             }
                         }) {
                             Text("eb.tickets_button").fontWeight(.semibold).frame(maxWidth: .infinity).padding().background(LinearGradient(colors: [Color.orange, .red], startPoint: .leading, endPoint: .trailing)).cornerRadius(12).foregroundColor(.white)
                         }.disabled(event.url == nil)
                     }
                 } // Fin VStack Contenido
                 .padding().background(Color.theme.cardBackground).cornerRadius(24)
                 .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                 .padding()
             } // Fin ScrollView
         } // Fin ZStack
         .foregroundColor(Color.theme.primaryText)
     }

    // Función para abrir el mapa
     func openMapForPlace() {
         var addressString = event.venue?.name ?? ""
         if let displayAddress = event.venue?.address?.displayAddress, !displayAddress.isEmpty {
             if !addressString.isEmpty { addressString += ", " }
             addressString += displayAddress
         }
         guard !addressString.isEmpty else { return }
         
         let geocoder = CLGeocoder()
         geocoder.geocodeAddressString(addressString) { (placemarks, error) in
             if let placemark = placemarks?.first, let location = placemark.location {
                 let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
                 mapItem.name = event.venue?.name ?? event.name?.text ?? "Evento"
                 mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
             } else {
                 print("Error geocoding: \(error?.localizedDescription ?? "unknown")")
             }
         }
     }
}
