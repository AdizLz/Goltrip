// Config.swift
// Lee las API keys desde Secrets.plist (NO subir Secrets.plist a Git)
// Copia Secrets.plist.example → Secrets.plist y llena tus keys reales.

import Foundation

enum Config {

    private static let secrets: [String: Any] = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let dict = NSDictionary(contentsOf: url) as? [String: Any]
        else {
            // En desarrollo, avisa en consola si falta el archivo
            print("⚠️  Config: no se encontró Secrets.plist. Copia Secrets.plist.example → Secrets.plist y llena tus keys.")
            return [:]
        }
        return dict
    }()

    /// Key de API-Sports (usada en JugadoresView y TablaGeneralView)
    static var apiSportsKey: String {
        secrets["API_SPORTS_KEY"] as? String ?? ""
    }

    /// Token de Eventbrite (usado en EventbriteService)
    static var eventbriteToken: String {
        secrets["EVENTBRITE_TOKEN"] as? String ?? ""
    }
}
