//
//  Theme.swift
//  iOSApp4
//
//  Created by Ahmad Wahidi on 2026-07-13.
//
//  Central theme definitions. Each workout type gets its own accent
//  color and gradient so cards, icons, and the timer ring stay
//  visually consistent across the whole app.
//

import SwiftUI

struct AppTheme {
    let name: String
    let accentColor: Color
    let iconGradient: LinearGradient
    let badgeBg: Color

    /// Maps a workout type to its theme so any view can ask
    /// `AppTheme.current(for:)` and style itself consistently.
    static func current(for type: WorkoutType) -> AppTheme {
        switch type {
        case .running:
            return AppTheme(
                name: "Trail Blaze",
                accentColor: .coral,
                iconGradient: LinearGradient(colors: [.coral, .orange], startPoint: .top, endPoint: .bottom),
                badgeBg: Color.coral.opacity(0.15)
            )
        case .cycling:
            return AppTheme(
                name: "Velo Rush",
                accentColor: .sky,
                iconGradient: LinearGradient(colors: [.sky, .blue], startPoint: .top, endPoint: .bottom),
                badgeBg: Color.sky.opacity(0.15)
            )
        case .strength:
            return AppTheme(
                name: "Iron Forge",
                accentColor: .amber,
                iconGradient: LinearGradient(colors: [.amber, .red], startPoint: .top, endPoint: .bottom),
                badgeBg: Color.amber.opacity(0.15)
            )
        case .yoga:
            return AppTheme(
                name: "Calm Flow",
                accentColor: .emerald,
                iconGradient: LinearGradient(colors: [.emerald, .teal], startPoint: .top, endPoint: .bottom),
                badgeBg: Color.emerald.opacity(0.15)
            )
        case .swimming:
            return AppTheme(
                name: "Deep Blue",
                accentColor: .indigo,
                iconGradient: LinearGradient(colors: [.indigo, .cyan], startPoint: .top, endPoint: .bottom),
                badgeBg: Color.indigo.opacity(0.15)
            )
        }
    }
}

// Custom palette colors (Tailwind-inspired) reused throughout the UI.
extension Color {
    static let slate = Color(red: 0.58, green: 0.65, blue: 0.75)
    static let emerald = Color(red: 0.06, green: 0.73, blue: 0.45)
    static let amber = Color(red: 0.96, green: 0.62, blue: 0.04)
    static let sky = Color(red: 0.22, green: 0.65, blue: 0.91)
    static let coral = Color(red: 0.98, green: 0.45, blue: 0.35)
}
