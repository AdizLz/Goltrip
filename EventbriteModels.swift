import Foundation

struct EventbriteResponse: Codable {
    let events: [EventbriteEvent]
}

struct EventbriteEvent: Codable, Identifiable {
    let id: String
    let name: EventbriteText? // Event title
    let description: EventbriteText? // Event description
    let url: String? // URL to the event page on Eventbrite
    let start: EventbriteDateTime?
    let end: EventbriteDateTime?
    let organization_id: String?
    let created: String?
    let changed: String?
    let published: String?
    let capacity: Int?
    let capacity_is_custom: Bool?
    let status: String?
    let currency: String?
    let listed: Bool?
    let shareable: Bool?
    let online_event: Bool?
    let tx_time_limit: Int?
    let hide_start_date: Bool?
    let hide_end_date: Bool?
    let locale: String?
    let is_locked: Bool?
    let privacy_setting: String?
    let is_series: Bool?
    let is_series_parent: Bool?
    let inventory_type: String?
    let is_reserved_seating: Bool?
    let show_pick_a_seat: Bool?
    let show_seatmap_thumbnail: Bool?
    let show_colors_in_seatmap_thumbnail: Bool?
    let source: String?
    let is_free: Bool?
    let version: String?
    let summary: String? // Shorter description
    let logo_id: String?
    // let logo: EventbriteImage? // You might need a struct for images
    let organizer_id: String?
    let venue_id: String?
    let category_id: String?
    let subcategory_id: String?
    let format_id: String?
    let resource_uri: String?
    // let series_id: String?
    // Add venue and other nested objects if needed
    let venue: EventbriteVenue?
}

// Helper structs for nested JSON objects
struct EventbriteText: Codable {
    let text: String?
    let html: String?
}

struct EventbriteDateTime: Codable {
    let timezone: String?
    let local: String? // Formatted date/time string (e.g., "2025-11-15T19:00:00")
    let utc: String?

    // Computed property to get a Date object (optional)
    var localDate: Date? {
        guard let localString = local else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Adjust if needed
        return formatter.date(from: localString) ?? ISO8601DateFormatter().date(from: localString) // Fallback without fractional seconds
    }
}

struct EventbriteVenue: Codable {
     let name: String?
     let address: EventbriteAddress?
     // Add other venue details if needed (lat/long, etc.)
}

struct EventbriteAddress: Codable {
    let address_1: String?
    let address_2: String?
    let city: String?
    let region: String? // State/Province
    let postal_code: String?
    let country: String?
    // You might want a computed property for a formatted address string
    var displayAddress: String {
        [address_1, city, region, postal_code, country]
            .compactMap { $0 } // Remove nil values
            .filter { !$0.isEmpty } // Remove empty strings
            .joined(separator: ", ")
    }
}
