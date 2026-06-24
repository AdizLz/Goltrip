// Archivo: ColorTheme.swift
import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let mainBackground = Color("mainBackground")
    let cardBackground = Color("cardBackground")
    let primaryAccent = Color("primaryAccent")
    let secondaryAccent = Color("secondaryAccent")
    let primaryText = Color("primaryText")
    let secondaryText = Color("secondaryText")
}
