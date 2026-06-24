// File: EventbriteService.swift
import Foundation

class EventbriteService {

    private let apiToken = Config.eventbriteToken
    private let baseUrl = "https://www.eventbriteapi.com/v3/events/search"

    // Function to fetch events based on city
    func fetchEvents(city: String) async throws -> [EventbriteEvent] {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "location.address", value: city), // Use city name for location search
            URLQueryItem(name: "location.within", value: "50km"), // Search radius (optional, adjust as needed)
            URLQueryItem(name: "expand", value: "venue"), // Include venue details in the response
            URLQueryItem(name: "sort_by", value: "date"), // Sort by date (optional)
 
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        print("Fetching Eventbrite URL: \(url.absoluteString)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                 if let responseString = String(data: data, encoding: .utf8) {
                     print("Error Response Body: \(responseString)")
                 }
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()
            let eventbriteResponse = try decoder.decode(EventbriteResponse.self, from: data)
            return eventbriteResponse.events

        } catch let decodingError as DecodingError {
            // Print detailed decoding errors
             print("Decoding Error: \(decodingError)")
             switch decodingError {
             case .typeMismatch(let type, let context):
                 print("Type '\(type)' mismatch:", context.debugDescription)
                 print("codingPath:", context.codingPath)
             case .valueNotFound(let type, let context):
                 print("Value '\(type)' not found:", context.debugDescription)
                 print("codingPath:", context.codingPath)
             case .keyNotFound(let key, let context):
                 print("Key '\(key)' not found:", context.debugDescription)
                 print("codingPath:", context.codingPath)
             case .dataCorrupted(let context):
                 print("Data corrupted:", context.debugDescription)
                 print("codingPath:", context.codingPath)
             @unknown default:
                 print("Unknown decoding error")
             }
            throw decodingError
        } catch {
            print("Failed to fetch events: \(error)")
            throw error
        }
    }
}
